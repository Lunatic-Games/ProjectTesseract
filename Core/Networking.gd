extends Node

const DEFAULT_PORT = 32200
const UDP_BROADCASTING_PORT = 32300
const MAX_PLAYERS = 20
const MAX_SEARCH_LOOP = 1000000

var connectedPlayers = { }

var broadcastThread
var localIP
var timer
var dataDict = {}
var broadcastSocket

func connect_player(id):
	rpc_id(id, "register_user", UserSettings.user_name)

func disconnect_player(id):
	connectedPlayers.erase(id)

func host():
	var localIPs = IP.get_local_addresses()
	var regex = RegEx.new()
	regex.compile('^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$')
	for ip in localIPs:
		var result = regex.search(ip)
		if (result and result.get_string() != "127.0.0.1"):
    		localIP = result.get_string()
	
	print("Hosting network with IP: " + str(localIP))
	print("Server is on port: " + str(DEFAULT_PORT))
	
	var openUPNPPort = $Panel/Container/VContainer/HContainer/Container/HContainer/upnpBroadcast.pressed
	if (openUPNPPort == false):
		var upnp = UPNP.new()
		upnp.discover(2000, 2, "InternetGatewayDevice")
		upnp.add_port_mapping(DEFAULT_PORT)
		print("Server (should) also be open on " + str(upnp.query_external_address()) + ":" + str(DEFAULT_PORT))
	
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(DEFAULT_PORT, MAX_PLAYERS)
	if res != OK:
		print("Error creating server")
		return

	get_tree().set_network_peer(host)
	
	broadcastThread = Thread.new()
	broadcastThread.start(self, "create_timer_for_broadcast")
	
func create_timer_for_broadcast(userdata):
	broadcastSocket = PacketPeerUDP.new()
	broadcastSocket.set_dest_address("255.255.255.255",UDP_BROADCASTING_PORT)
	
	dataDict = {}
	dataDict["name"] = "Default Name"
	dataDict["ip"] = localIP
	
	print("Advertising lobby via UDP every second on port " + str(UDP_BROADCASTING_PORT) + " to address 255.255.255.255 with payload:" )
	print(JSON.print(dataDict))
	
	timer = Timer.new()
	timer.set_wait_time(1.0)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "broadcast_port")
	add_child(timer)
	timer.start()

func broadcast_port():
	broadcastSocket.put_packet(JSON.print(dataDict).to_ascii())

func attempt_connect(goalIP):
	print("Joining network")
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_client(goalIP,DEFAULT_PORT)
	if res != OK:
		print("Error joining server")
		return
	saveIP()
	get_tree().set_network_peer(host)
	
func search_for_local_networks():
	var done = false
	var loopCount = 0
	var socket = PacketPeerUDP.new()
	if (socket.listen(UDP_BROADCASTING_PORT) != OK):
		print("An error occurred listening on port "+ str(UDP_BROADCASTING_PORT))
		return
	while(done != true and loopCount < MAX_SEARCH_LOOP):
		if(socket.get_available_packet_count() > 0):
			var data = JSON.parse(socket.get_packet().get_string_from_ascii())
			if(data.error == OK and data.result.has("name") and data.result.has("ip") and data.result["name"] != "" and data.result["ip"] != ""):
				done = true
				$Panel/Container/VContainer/HContainer/Container/HContainer/IPValue.text = data.result["ip"]
				saveIPFromParam(data.result["ip"])
				socket.close()
				return
		loopCount += 1
	socket.close()        
	print("No Packets Recieved. Stopping Search")

func saveIP():
	var save_data = {
		"ip" : $Panel/Container/VContainer/HContainer/Container/HContainer/IPValue.text
	}
	var save_file = File.new()
	save_file.open("user://lastIP.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()
	
func saveIPFromParam(ipAddress):
	var save_data = {
		"ip" : str(ipAddress) 
	}
	var save_file = File.new()
	save_file.open("user://lastIP.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()
		
remote func register_user(name):
	var id = get_tree().get_rpc_sender_id()
	connectedPlayers[id] = name
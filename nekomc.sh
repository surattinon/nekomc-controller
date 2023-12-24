#!/bin/bash

# Define the Java process name
java_process="java"

# Error
error() {
	echo "Invalid options and arguments :"
	help
}
# Help function
help() {
	# Display help
	echo "nekomc [options] [arguments]"
	echo "[options] -u, --up | -d, --down"
	echo "[arguments] all, main, lobby, velocity"
}

startall() {
	echo "starting all server..."
	# Start main server session0 pane0
	tmux send-keys -t 0.0 'cd /home/basu/minecraft_server/colo_mc_1.20.1/ && ./start.sh' Enter
	# Start lobby server session0 pane1
	tmux send-keys -t 0.1 'cd /home/basu/minecraft_server/lobby/ && ./start.sh' Enter
	# Start velocity server session0 pain2
	tmux send-keys -t 0.2 'cd /home/basu/minecraft_server/Velocity/ && ./start.sh' Enter
	echo "all server started."
}

stopall() {
	echo "stopping all server..."
	# Stop main server session0 pane0
	tmux send-keys -t 0.0 'stop' Enter

	# Stop lobby server session0 pane1
	tmux send-keys -t 0.1 'stop' Enter

	# Stop velocity server session0 pain2
	tmux send-keys -t 0.2 'stop' Enter

	sleep 5

	if pgrep -x "$java_process" >/dev/null; then
		echo "Java process is running."
		echo "Stoping Java process....."

		# Check for changes in the process status
		while pgrep -x "$java_process" >/dev/null; do

			# Force Stop main server session0 pane0
			tmux send-keys -t 0.0 C-c

			# Force Stop lobby server session0 pane1
			tmux send-keys -t 0.1 C-c

			sleep 1
		done

		# If the loop exits, it means the Java process has stopped
		echo "Java process has stopped."
		echo "All server stopped successfully."
	else
		echo "Java process is not running."
	fi
}

while [ True ]; do
	# Start server options
	if [ "$1" = "--up" -o "$1" = "-u" ]; then
		if [ "$2" = "all" ]; then
			startall
			break
		elif [ "$2" = "main" ]; then
			# Start main server session0 pane0
			echo "starting main..."
			tmux send-keys -t 0.0 'cd /home/basu/minecraft_server/colo_mc_1.20.1/ && ./start.sh' Enter
			echo "main started."
			break
		elif [ "$2" = "lobby" ]; then
			# Start lobby server session0 pane1
			echo "starting lobby..."
			tmux send-keys -t 0.1 'cd /home/basu/minecraft_server/lobby/ && ./start.sh' Enter
			echo "lobby started."
			break
		elif [ "$2" = "velocity" ]; then
			# Start velocity server session0 pane2
			echo "starting velocity..."
			tmux send-keys -t 0.2 'cd /home/basu/minecraft_server/Velocity/ && ./start.sh' Enter
			echo "velocity started."
			break
		fi
		# Stop server options
	elif [ "$1" = "--down" -o "$1" = "-d" ]; then
		if [ "$2" = "all" ]; then
			stopall
			break
		elif [ "$2" = "main" ]; then
			# Stop main server session0 pane0
			tmux send-keys -t 0.0 'stop' Enter
			echo "stopping main..."

			sleep 4

			if pgrep -x "$java_process" >/dev/null; then
				echo "Java process is running."
				echo "Stoping Java process....."

				# Force Stop server
				tmux send-keys -t 0.0 C-c

				echo "Java process has stopped."
				echo "main stopped successfully."
			else
				echo "Java process is not running."
			fi
			break
		elif [ "$2" = "lobby" ]; then
			# Stop lobby server session0 pane1
			tmux send-keys -t 0.1 'stop' Enter
			echo "stopping lobby..."

			sleep 4

			if pgrep -x "$java_process" >/dev/null; then
				echo "Java process is running."
				echo "Stoping Java process....."

				# Force Stop server
				tmux send-keys -t 0.1 C-c

				echo "Java process has stopped."
				echo "Lobby stopped successfully"
			else
				echo "Java process is not running."
			fi
			break
		elif [ "$2" = "velocity" ]; then
			# Stop velocity server session0 pane1
			tmux send-keys -t 0.2 'stop' Enter
			echo "velocity stopped successfully."
			break
		fi
		# List Help
	elif [ "$1" = "--help" -o "$1" = "-h" ]; then
		help
		break
	else
		error
		break
	fi
done

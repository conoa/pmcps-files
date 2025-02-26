build:
	docker compose build

ps:
	docker compose ps

up:
	docker compose up -d

stop:
	 docker stop $(docker ps -aq)

clean:
	$(shell ./clean-docker.sh)

ssh-mgmt:
	ssh-keygen -f "/home/marten/.ssh/known_hosts" -R "[localhost]:2223"
	ssh-copy-id -p 2223 ansible@localhost 
	ssh ansible@localhost -p 2223

copy-sshkeys:
	rm -f /home/marten/.ssh/known_hosts
	ssh-copy-id -f -p 2223 ansible@localhost

ssh-airgap:
	ssh -p '2223' 'ansible@localhost'

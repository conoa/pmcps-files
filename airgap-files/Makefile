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
	ssh-keygen -f "/home/marten/.ssh/known_hosts" -R "[localhost]:2221"
	ssh-copy-id -p 2221 ansible@localhost 
	ssh ansible@localhost -p 2221

copy-sshkeys:
	rm -f /home/marten/.ssh/known_hosts
	ssh-copy-id -f -p 2221 ansible@localhost

ssh-airgapfiles:
	ssh -p '2221' 'ansible@localhost'

.PHONY: build clean test

keydir = cmd/busboy/keys
hash = $(shell git log --pretty=format:'%h' -n 1)

build: clean $(keydir)
	mkdir -p build
	go build -o build/busboy -ldflags "-X main.build=${hash}" cmd/busboy/main.go

test: $(keydir)
	go test ./...

run: $(keydir)
	go run cmd/busboy/main.go

clean:
	rm -rf build
	rm -rf $(keydir)

$(keydir):
	mkdir -p $(keydir)
# Generate private key (.key)
	openssl genrsa -out $(keydir)/server.key 2048
	openssl ecparam -genkey -name secp384r1 -out $(keydir)/server.key
# Generation of self-signed(x509) public key (PEM-encodings .pem|.crt) based on the private (.key)
	openssl req -new -x509 -sha256 -key $(keydir)/server.key -out $(keydir)/server.crt -days 3650 \
		-subj "/C=AU/ST=NSW/L=Sydney/O=Test Site/CN=example.com"


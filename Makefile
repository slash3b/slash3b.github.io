install:
	go install github.com/gohugoio/hugo@latest

run:
	hugo serve -DEF --disableFastRender --printMemoryUsage --tlsAuto


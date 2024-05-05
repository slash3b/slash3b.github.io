install:
	go install github.com/gohugoio/hugo@latest

run:
	hugo serve -DEF --disableFastRender --printMemoryUsage --tlsAuto

themeupd:
	@cd themes/PaperMod/
	@git pull origin master

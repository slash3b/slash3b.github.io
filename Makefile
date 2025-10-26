install:
	# at the time of writing — latest compatible version
	go install github.com/gohugoio/hugo@v0.140.2

run:
	hugo serve -DEF --disableFastRender --printMemoryUsage --tlsAuto

themeupd:
	@cd themes/PaperMod/
	@git pull origin master

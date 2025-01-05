install:
	# at the time of writing — latest compatible version
	go install github.com/gohugoio/hugo@0.123.0

run:
	hugo serve -DEF --disableFastRender --printMemoryUsage --tlsAuto

themeupd:
	@cd themes/PaperMod/
	@git pull origin master

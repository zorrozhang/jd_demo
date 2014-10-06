# This imports all the layers for "timeline" into timelineLayers
timelineLayers = Framer.Importer.load "imported/timeline"

# This imports all the layers for "street" into streetLayers
streetLayers = Framer.Importer.load "imported/street"

# This imports all the layers for "index" into indexLayers
indexLayers = Framer.Importer.load "imported/index"

primaryColor = '#e5504c'
deviceWidth = 640
deviceHeight = 1136
statusBarHeight = 44
topBarHeight = 128

# Animation of forwarding to the next page
push = (nextPage) ->
	
	bg      = nextPage.bg # Naming convention
	topbar  = nextPage.topBar
	content = nextPage.content
	
	# Stop if this page is already exists
	if topbar.subLayersByName('backBtn')[0]
		return
	# Generating the page to be pushed
	page = generatePage(bg, topbar, content)
	
	page.x = deviceWidth
	page.bringToFront()
	page.animate
		properties: {x: 0}
		time: 0.3
	
	return page

# Animation of going back to the previous page
pull = (thisPage) ->
	ani = thisPage.animate
		properties: {x: deviceWidth}
		time: 0.3
	
# 	page = thisPage
	
# 	ani.on('stop', -> console.log(thisPage.destroy()))
	
# 	return page

# Generating a fully functional page layer
generatePage = (bgLayer, topbarLayer, contentLayer) ->
	pageLayer = new Layer
		width: deviceWidth
		height: topbarLayer.height + contentLayer.height
		backgroundColor: 'transparent'
# 	pageLayer.image = bgLayer.image	
	
	# Back button on top bar
	backBtnLayer = new Layer
		y: statusBarHeight
		width: 160
		height: topBarHeight - statusBarHeight
		backgroundColor: 'transparent'
	
	backBtnLayer.on Events.TouchEnd, ->
		pull(pageLayer)
		topbarLayer.subLayersByName('backBtn')[0].destroy() # Prevent having duplicated btns
	
	topbarLayer.addSubLayer(backBtnLayer)
	
	contentLayer.name = 'content'
	topbarLayer.name  = 'topbar'
	backBtnLayer.name = 'backBtn'
	
	pageLayer.addSubLayer(bgLayer)
	pageLayer.addSubLayer(contentLayer)
	pageLayer.addSubLayer(topbarLayer)	
		
	return pageLayer

# Setting content scrollable and snapped to the chat list
makeScrollable = (contentLayer, offset = 910) ->
	contentLayer.draggable.enabled = true
	contentLayer.draggable.speedX = 0
	contentLayer.draggable.speedY = 0.6
	
	originX = contentLayer.x
	originY = contentLayer.y
	
	# Snap the chat list
	contentLayer.on Events.DragEnd, (event, layer) ->
		if layer.y > originY
			layer.animate
				properties:
					x: originX
					y: originY
				curve: "spring"
				curveOptions:
					friction: 20
					tension: 200
					velocity: 10
			
		if layer.y < originY - layer.height + offset
			layer.animate
				properties:
					x: originX
					y: originY - layer.height + offset
				curve: "spring"
				curveOptions:
					friction: 20
					tension: 200
					velocity: 10
					
	return contentLayer

contentLayer = indexLayers.content
contentLayer = makeScrollable(contentLayer)

card1 = indexLayers.card1
card2 = indexLayers.card2
card3 = indexLayers.card3
card4 = indexLayers.card4
card5 = indexLayers.card5
card6 = indexLayers.card6
card7 = indexLayers.card7
card8 = indexLayers.card8
card9 = indexLayers.card9

cards = [card1, card2, card3, card4, card5, card6, card7, card8]
cardText = ['数码','美妆','美食','户外','家居','礼物','旅行','新奇特']
cardTextLayer = []

cardWidth = 580
cardHeight = 110

[0..cards.length - 1].map (i) ->
	cardTextLayer[i] = new Layer
		width: cardWidth
		height: cardHeight
		backgroundColor: 'transparent'
		
	cardTextLayer[i].style =
		color: '#fff'
		fontSize: '48px'
		lineHeight: cardHeight + 'px'
		textAlign: 'center'
		fontWeight: 'bold'
		textShadow: '0 0 6px rgba(0,0,0,.4)'
	cardTextLayer[i].html = cardText[i]
	
	waveLayer = new Layer
		backgroundColor: 'rgba(229,80,76,.95)'
		width: cardHeight
		height: cardHeight
		x: cardWidth / 2 - cardHeight / 2
		opacity: 0
	waveLayer.name = 'waveLayer'
	waveLayer.style = 
		borderRadius: '50%'
	
	cards[i].addSubLayer(waveLayer)
	cards[i].addSubLayer(cardTextLayer[i])
	cards[i].states.add 'selected', {scale:1}
	cards[i].style = 
		overflow: 'hidden'
		borderRadius: '10px'
	
	animating = false	
	cards[i].on Events.Click, ->
		if contentLayer.draggable.calculateVelocity().y == 0
			wave = this.subLayersByName('waveLayer')[0]
			
			if animating
				wave.animateStop()
				
			this.states.next()			
			aniTime = 0.1
			
			animating = true
			
			if this.states.current == 'selected'
				ani = wave.animate
					properties:
						scale: 6
						opacity: 1
					curve: 'spring'
					curveOptions:
						friction: 55
					time: aniTime				
				ani.on('stop', ->
					animating = false
					)
				
			else if this.states.current == 'default'
				ani = wave.animate
					properties:
						scale: 1
						opacity: 0
					curve: 'spring'
					curveOptions:
						friction: 80
					time: aniTime
				ani.on('stop', ->
					animating = false
					)
			
buttonLayer = indexLayers.button
btnLayer = new Layer
	width: buttonLayer.width
	height: buttonLayer.height
	backgroundColor: 'transparent'
btnLayer.style =
	borderRadius: '10px'
	lineHeight: cardHeight + 'px'
	color: primaryColor
	fontSize: '34px'
	textAlign: 'center'
btnLayer.html = '前往逛街'

buttonLayer.addSubLayer(btnLayer)

# Button active effect
btnLayer.on Events.TouchStart, ->
	this.backgroundColor = primaryColor
	this.style = {color: '#fff'}

# Change card1 to btnLayer	
card1.on Events.TouchEnd, ->
	this.backgroundColor = 'transparent'
	this.style = {color: primaryColor}
	
	goods1 = timelineLayers.goods1
	goods2 = timelineLayers.goods2
	goods3 = timelineLayers.goods3
# 	goods4 = timelineLayers.goods2
# 	goods5 = timelineLayers.goods1
# 	goods6 = timelineLayers.goods2
	
	goodsToShowNum = 8
	goodsWidth = 290
	goodsHeight = 450
	goodsMargin = 20
	
	goodsAll = [goods1, goods2, goods3]
	goodsLeft = goodsAll
	goodsToShow = []
	
	[0..goodsAll.length - 1].map (i)->
		console.log(i)
# 		goodsAll[i].visible = false
		choice = Math.floor(Math.random() * goodsLeft.length)
# 		console.log(choice)
		goods = goodsLeft[choice]
# 		console.log(goods)
		
		# Remove the chosen goods
		goodsLeft.splice(choice, 1)
		
		# Add goods to content
		if i > 0
			goods.x = i % 2 * (goodsWidth + goodsMargin)
			goods.y = (Math.floor((i + 1) / 2)) * goodsHeight + goodsMargin
			goods.html = i
		else
			goods.x = 0
			goods.y = 0
			goods.html = i
		
		
	
# 	Push page Timeline
	timelinePage = push(timelineLayers,indexLayers)
	timelineContent = timelinePage.subLayersByName('content')[0]
	makeScrollable(timelineContent)
			
	# Push page Street
# 	streetPage = push(streetLayers,indexLayers)
# 	
# 	navLayer = streetLayers.nav
# 	eleLayer = streetLayers.elevator
# 	
# 	streetBtnWidth = 138
# 	
# 	streetNames = ['女鞋街', '男鞋街', '服装城', '美妆店', '美食城', '运动街', '趣玩店', '家具城']
# 	[0..streetNames.length - 1].map (i) ->
# 		street = new Layer
# 			width: streetBtnWidth
# 			height: navLayer.height
# 	
# 	
# 	nav = new Layer
# 		x: eleLayer.width
# # 		y: navLayer.y
# 		width: streetNames.length * streetBtnWidth
# 		height: navLayer.height
# 		
# 	nav.draggable.enabled = true
# 	nav.draggable.speedX = 0.8
# 	nav.draggable.speedY = 0
# 	
# 	originX = nav.x
# 	originY = nav.y
# 	
# 	# Snap the chat list
# 	nav.on Events.DragEnd, (event, layer) ->
# 		if layer.x > originX
# 			layer.animate
# 				properties:
# 					x: originX
# 					y: originY
# 				curve: "spring"
# 				curveOptions:
# 					friction: 20
# 					tension: 200
# 					velocity: 10
# 			
# 		if layer.x < originX - layer.width + deviceWidth - eleLayer.width
# 			layer.animate
# 				properties:
# 					x: originX - layer.width + deviceWidth - eleLayer.width
# 					y: originY
# 				curve: "spring"
# 				curveOptions:
# 					friction: 20
# 					tension: 200
# 					velocity: 10
# 	
# 	
# 	
# 	navLayer.addSubLayer(nav)
# 	eleLayer.bringToFront()
# 	
# 	streetPage.addSubLayer(navLayer)
# 	streetPage.height = deviceHeight
# 	
# 	content = streetPage.subLayersByName('content')[0]
# 	makeScrollable(content)
	
# Add events here
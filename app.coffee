# # This imports all the layers for "wechat" into wechatLayers
# wechatLayers = Framer.Importer.load "imported/wechat"

# # So to hide the layer for a group named "Main Screen" you can do:

generateTabbarButton = () ->
	buttonLayer = new Layer
		x : 0
		y : 1136 - 98
		width : 155
		height : 100
# 	buttonLayer.backgroundColor = null
	return buttonLayer

generateNormalLayer = () ->
	normalLayer = new Layer
		x : 0
		y : 0
		width : 640
		height : 1136
	return normalLayer

generateDragableFullScreenLayer  = (background, topbar, content, bottom, logo, contentHeight) ->

	containerLayer = new Layer
		x : 0
		y : 0
		width : 640
		height : 1136
	containerLayer.image = background
	containerLayer.scrollVertical = true
	
	tempLayer = new Layer
		x : 0
		y : 0
		width : 640
		height : 1037
	tempLayer.image = background

	containerLayer.addSubLayer tempLayer
	
	if logo != null
		logoLayer = new Layer
		logoLayer.image = logo
		logoLayer.frame = new Frame
			x : (tempLayer.width - 120)/2.0
			y : 0
			width : 120
			height : 100
		tempLayer.addSubLayer logoLayer
	
	contentLayer = new Layer
	contentLayer.image = content
	contentLayer.frame = new Frame
		x : 0
		y : 128
		width : containerLayer.width
		height : 910
	tempLayer.addSubLayer contentLayer
	
	topBarLayer = new Layer
	topBarLayer.image = topbar
	topBarLayer.frame = new Frame
		x : 0
		y : 0
		width : containerLayer.width
		height : 128
	containerLayer.addSubLayer topBarLayer
		
	bottombarLayer = new Layer
	bottombarLayer.image = bottom 
	bottombarLayer.frame = new Frame
		x : topBarLayer.x
		y : contentLayer.y + contentLayer.height
		width : containerLayer.width
		height : containerLayer.height - topBarLayer.height - contentLayer.height
	containerLayer.addSubLayer bottombarLayer
	
	firstTabButton = generateTabbarButton()
	firstTabButton.x = 0;
	firstTabButton.on Events.Click, ->
		showMainFrameTabView()
	containerLayer.addSubLayer firstTabButton
	
	secondTabButton = generateTabbarButton()
	secondTabButton.x = 160;
	secondTabButton.on Events.Click, ->
		showContactTabView()
	containerLayer.addSubLayer secondTabButton
	
	thirdTabButton = generateTabbarButton()
	thirdTabButton.x = 320;
	thirdTabButton.on Events.Click, ->
		showFindFriendTabView()
	containerLayer.addSubLayer thirdTabButton
	
	fourTabButton = generateTabbarButton()
	fourTabButton.x = 480;
	fourTabButton.on Events.Click, ->
		showMoreTabView()
	containerLayer.addSubLayer fourTabButton
	
	contentLayer.enabled = true
	contentLayer.draggable.enabled = true
	contentLayer.draggable.speedX = 0
	contentLayer.draggable.speedY  = 0.5
	originX = contentLayer.x
	originY = contentLayer.y
	contentLayer.height = contentHeight
	contentLayer.backgroundColor = "#7ed6ff"
		
	contentLayer.on Events.DragEnd, (event, layer) ->	
			if layer.y > originY
				# Snap the chat list
				layer.animate
					properties:
						x: originX
						y: originY
					curve: "spring"
					curveOptions:
						friction: 20
						tension: 200
						velocity: 10
				
			if layer.y < originY - layer.height + 910
								# Snap the chat list
				layer.animate
					properties:
						x: originX
						y: originY - layer.height + 910
					curve: "spring"
					curveOptions:
						friction: 20
						tension: 200
						velocity: 10
						
	return containerLayer

generateScrollableFullScreenLayerImpl = (background, topbar, content, bottom, logo, contentHeight, needTabbar) ->
	containerLayer = new Layer
		x : 0
		y : 0
		width : 640
		height : 1136
	
	containerLayer.image = background
		
	tempLayer = new Layer
		x : 0
		y : 0
		width : 640
		height : 1037
	tempLayer.image = background
	tempLayer.scrollVertical = true
	if bottom == null
		tempLayer.height = 1136
	containerLayer.addSubLayer tempLayer
	
	if logo != null
		logoLayer = new Layer
		logoLayer.image = logo
		logoLayer.frame = new Frame
			x : (tempLayer.width - 120)/2.0
			y : 178
			width : 120
			height : 100
		containerLayer.addSubLayer logoLayer
	
	contentLayer = new Layer
	contentLayer.image = content
	contentLayer.frame = new Frame
		x : 0
		y : 128
		width : tempLayer.width
		height : 910
	tempLayer.addSubLayer contentLayer
	
	topBarLayer = new Layer
	topBarLayer.image = topbar
	topBarLayer.frame = new Frame
		x : 0
		y : 0
		width : tempLayer.width
		height : 128
	containerLayer.addSubLayer topBarLayer
		
	if bottom != null
		bottombarLayer = new Layer
		bottombarLayer.image = bottom 
		bottombarLayer.frame = new Frame
			x : topBarLayer.x
			y : contentLayer.y + contentLayer.height
			width : tempLayer.width
			height : tempLayer.height - topBarLayer.height - contentLayer.height
		containerLayer.addSubLayer bottombarLayer
		
		if needTabbar
			firstTabButton = generateTabbarButton()
			firstTabButton.x = 0;
			firstTabButton.on Events.Click, ->
				showMainFrameTabView()
			containerLayer.addSubLayer firstTabButton
			
			secondTabButton = generateTabbarButton()
			secondTabButton.x = 160;
			secondTabButton.on Events.Click, ->
				showContactTabView()
			containerLayer.addSubLayer secondTabButton
			
			thirdTabButton = generateTabbarButton()
			thirdTabButton.x = 320;
			thirdTabButton.on Events.Click, ->
				showFindFriendTabView()
			containerLayer.addSubLayer thirdTabButton
			
			fourTabButton = generateTabbarButton()
			fourTabButton.x = 480;
			fourTabButton.on Events.Click, ->
				showMoreTabView()
			containerLayer.addSubLayer fourTabButton

	contentLayer.height = contentHeight	
	return containerLayer
	
generateScrollableFullScreenLayer = (background, topbar, content, bottom, logo, contentHeight) ->
	return generateScrollableFullScreenLayerImpl(background, topbar, content, bottom, logo, contentHeight, true)
	
generateFullScreenLayer = (background, topbar, content, bottom, logo, contentHeight) ->
	if contentHeight > 1136
		return generateScrollableFullScreenLayer(background, topbar, content, bottom, logo, contentHeight)
	else 
		return generateDragableFullScreenLayer(background, topbar, content, bottom, logo, contentHeight)
		
showMainFrameTabView = () ->
	firstTab.visible = true
	secondTab.visible = false
	thirdTab.visible = false
	fourTab.visible = false
	
showContactTabView = () ->
	firstTab.visible = false
	secondTab.visible = true
	thirdTab.visible = false
	fourTab.visible = false

showFindFriendTabView = () ->
	firstTab.visible = false
	secondTab.visible = false
	thirdTab.visible = true
	fourTab.visible = false
	
showMoreTabView = () ->
	firstTab.visible = false
	secondTab.visible = false
	thirdTab.visible = false
	fourTab.visible = true
	
pushViewController = (bottomView, clickCell, topView) ->
	if clickCell != null
		clickCell.backgroundColor = "#d9d9d9"
		clickCell.opacity = 0.8
	
	viewPage = topView
	topView.x = 640
	
	addBackButton(bottomView, null, topView)
		
	viewPage.animate
    properties:
      x: 0
      y: 0
    curve: "bezier-curve"
    time: 0.5
		delay: 0.1
			
	bottomView.animate
		properties:
			x: -160
			y: 0
	curve: "bezier-curve"
	time: 0.5
	delay: 0.1

addBackButton = (bottomView, clickCell, topView) ->
	backButton = new Layer
		x : 0
		y : 40
		width : 140
		height : 88
# 	backButton.backgroundColor = null
	topView.addSubLayer backButton
	
	backButton.on Events.Click, ->
# 		clickCell.backgroundColor = null
# 		clickCell.opacity = 1.0
		
		topView.animate
			properties:
				x: 640
				y: 0
			curve: "bezier-curve"
			time: 0.5
			
		bottomView.x = -20
		bottomView.animate
			properties:
				x: 0
				y: 0
		curve: "bezier-curve"
		time: 0.01
		
	topView.on Events.AnimationEnd, ->
		if topView.x == 640
			topView.visible = false
	
addJingdongDetailButton = (bottomView) ->
	detailButton = new Layer
		x : 0
		y : 380
		width : 320
		height : 415
# 	detailButton.backgroundColor = null
	bottomView.addSubLayer detailButton
	
	detailButton.on Events.Click, ->
		detailView = generateScrollableFullScreenLayerImpl("images/gray_background.jpg", 
			    "images/jingdong/detailpage/product_topbar.jpg",
				"images/jingdong/detailpage/product_content.jpg",
				"images/jingdong/detailpage/product_bottombar.jpg", null, 1531, false)
		pushViewController(bottomView, null, detailView)
		
		buyButton = new Layer 
			x : 10
			y : 1136 - 98
			width : 220
			height : 98
		buyButton.background = null
		detailView.addSubLayer buyButton
		
		buyButton.on Events.Click, ->
			productSku = generateNormalLayer()
			productSku.image = "images/jingdong/detailpage/product_sku.png"
			pushViewController(detailView, null, productSku)
			
			confirmButton = new Layer
				x : 160
				y : 1136 - 120
				width : 350
				height : 84
			productSku.addSubLayer confirmButton
			
			confirmButton.on Events.Click, ->
				payView  = generateNormalLayer()
				payView.image = "images/jingdong/detailpage/product_pay.jpg"
				pushViewController(detailView, null, payView)
				
				detailView.x = 0
				productSku.on Events.AnimationEnd, ->
					if productSku.x < 0
						productSku.x = -640
						productSku.visible = false
						
	centerBarButton = new Layer
		x : 260
		y : 40
		width : 150
		height : 88
	bottomView.addSubLayer centerBarButton
	centerBarButton.on Events.Click, ->
		centerDownList(bottomView)

centerDownList = (bottomView) ->
		centerBarClickView = generateNormalLayer();
		centerBarClickView.image  = "images/jingdong/detailpage/click_center_bar.png"
		pushViewController(bottomView, null, centerBarClickView)
		
		classifyButton = new Layer
			x : 250
			y : 223
			width : 150
			height : 55
		centerBarClickView.addSubLayer classifyButton
		classifyButton.on Events.Click, ->
			classifyHomePageView = generateNormalLayer()
			classifyHomePageView.image = "images/jingdong/detailpage/classify_page.png"
			pushViewController(centerBarClickView, null, classifyHomePageView)
		
		wishListButton = new Layer
			x : 250
			y : 298
			width : 150
			height : 55
		centerBarClickView.addSubLayer wishListButton
		wishListButton.on Events.Click, ->
			wishList(centerBarClickView)
		
		userCenterButton = new Layer
			x : 250
			y : 378
			width : 150
			height : 55
		centerBarClickView.addSubLayer userCenterButton
		userCenterButton.on Events.Click, ->
			userCenterView = generateNormalLayer()
			userCenterView.image = "images/jingdong/detailpage/user_center.png"
			pushViewController(centerBarClickView, null, userCenterView)
			allOrderButton = new Layer
				x : 0
				y : 313
				width : 640
				height : 79
			userCenterView.addSubLayer allOrderButton
			allOrderButton.on Events.Click, ->
				allOrder(userCenterView)
			wishListButton = new Layer
				x : 0
				y : 663
				width : 640
				height : 79
			userCenterView.addSubLayer wishListButton
			wishListButton.on Events.Click, ->
				wishList(userCenterView)
		
		allOrderButton = new Layer
				x : 250
				y : 448
				width : 150
				height : 55
		centerBarClickView.addSubLayer allOrderButton
		allOrderButton.on Events.Click, ->
			allOrder(centerBarClickView)
		

allOrder = (bottomView) ->
			allOrderView = generateNormalLayer()
			allOrderView.image = "images/jingdong/detailpage/all_order.png"
			pushViewController(bottomView, null, allOrderView)
			
wishList = (bottomView) ->
			wishListView = generateNormalLayer()
			wishListView.image = "images/jingdong/detailpage/wish_list.png"
			pushViewController(bottomView, null, wishListView)
			
			wishListFocusButton = new Layer
				x : 0
				y : 373
				width : 640
				height : 79
			wishListView.addSubLayer wishListFocusButton
			wishListFocusButton.on Events.Click, ->
				wishListFocus(wishListView)

wishListFocus = (bottomView) ->
			wishListFocusView = generateNormalLayer()
			wishListFocusView.image = "images/jingdong/detailpage/wish_list_focus.png"
			pushViewController(bottomView, null, wishListFocusView)


pushJingdongHomepage = (clickCell) ->
# 	clickCell.backgroundColor = "#d9d9d9"
# 	clickCell.opacity = 0.8
	
	if thirdTab.name == "firsttime_homepage"
		viewPage = new Layer
			x : 640
			y : 0
			width : 640
			height : 1136
		viewPage.image = "images/jingdong/homepage/firsttime_homepage.png"
		
		enterButton = new Layer
			x : (640 - 240)/2.0
			y : 1136 - 110 - 50
			width : 240
			height : 50
# 		enterButton.backgroundColor = null
		viewPage.addSubLayer enterButton
		enterButton.on Events.Click, ->
			homepage = generateScrollableFullScreenLayer("images/gray_background.jpg", 				
			    "images/jingdong/homepage/homepage_topbar.png",
				"images/jingdong/homepage/homepage_content.png",
				null, null, 1932)	
			addBackButton(thirdTab, clickCell, homepage)
			viewPage.x = 640
			viewPage.visible = false
			addJingdongDetailButton(homepage)
		
		thirdTab.name = null
	else 
		viewPage = generateScrollableFullScreenLayer("images/gray_background.jpg", 
			    "images/jingdong/homepage/homepage_topbar.png",
				"images/jingdong/homepage/homepage_content.png",
				null, null, 1932)	
		viewPage.x = 640
		addJingdongDetailButton(viewPage)
	
	addBackButton(thirdTab, clickCell, viewPage)
		
	viewPage.animate
    properties:
      x: 0
      y: 0
    curve: "bezier-curve"
    time: 0.5
		delay: 0.1
			
	thirdTab.animate
		properties:
			x: -160
			y: 0
	curve: "bezier-curve"
	time: 0.5
	delay: 0.1


addSpecialEventForFindFriend = () ->
	shoppingLayer = new Layer
		x : 0
		y : thirdTab.height - 320 - 98
		width : thirdTab.width
		height : 88
# 	shoppingLayer.backgroundColor = #FFFFFF
	thirdTab.addSubLayer shoppingLayer
	shoppingLayer.on Events.Click, ->
		pushJingdongHomepage(shoppingLayer)

firstTab = generateFullScreenLayer("images/black_background.png", 		"images/mainframe/mainframe_topbar.jpg",
"images/mainframe/mainframe_content.jpg",
"images/mainframe/mainframe_bottombar.jpg",
"images/mainframe/mainframe_logo.png",
9000)

secondTab = generateFullScreenLayer("images/black_background.png", 		"images/contactview/contactview_topbar.jpg", "images/contactview/contactview_content.jpg", "images/contactview/contactview_bottombar.jpg",
null,
6000)

thirdTab = generateFullScreenLayer("images/gray_background.jpg", 		"images/findfriend/findfriend_topbar.jpg", "images/findfriend/findfriend_content.jpg", "images/findfriend/findfriend_bottombar.jpg",
null,
910)

thirdTab.name = "firsttime_homepage"
addSpecialEventForFindFriend()

fourTab = generateFullScreenLayer("images/gray_background.jpg", 		"images/moreview/moreview_topbar.jpg",
"images/moreview/moreview_content.jpg", "images/moreview/moreview_bottombar.jpg",
null,
910)

#showMainFrameTabView()
#showFindFriendTabView()å
#thirdTab.name = null
pushJingdongHomepage()



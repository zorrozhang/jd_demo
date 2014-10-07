# # This imports all the layers for "wechat" into wechatLayers
# wechatLayers = Framer.Importer.load "imported/wechat"

# # So to hide the layer for a group named "Main Screen" you can do:

######### 定义全局变量
STATUSBAR_HEIGHT = 0
SCREEN_HEIGHT = 1136 - 40
SCREEN_WIDTH = 640
TABBAR_HEIGHT = 98
TOPBAR_HEIGHT = 88
#########

makeLighterLayer = (layer) ->
# 	layer.backgroundColor = "#3188f3"
# 	layer.opacity = 0.1
	
generateTabbarButton = () ->
	buttonLayer = new Layer
		x : 0
		y : SCREEN_HEIGHT - TABBAR_HEIGHT
		width : 155
		height : 100
	makeLighterLayer(buttonLayer)
	return buttonLayer

generateNormalLayer = () ->
	normalLayer = new Layer
		x : 0
		y : STATUSBAR_HEIGHT
		width : SCREEN_WIDTH
		height : SCREEN_HEIGHT
	return normalLayer

generateDragableFullScreenLayer  = (background, topbar, content, bottom, logo, contentHeight) ->

	containerLayer = generateNormalLayer()
	containerLayer.image = background
	containerLayer.scrollVertical = true
	
	tempLayer = new Layer
		x : 0
		y : 0
		width : SCREEN_WIDTH
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
		y : 88
		width : containerLayer.width
		height : 910
	tempLayer.addSubLayer contentLayer
	
	topBarLayer = new Layer
	topBarLayer.image = topbar
	topBarLayer.frame = new Frame
		x : 0
		y : 0
		width : containerLayer.width
		height : TOPBAR_HEIGHT
	containerLayer.addSubLayer topBarLayer
		
	bottombarLayer = new Layer
	bottombarLayer.image = bottom 
	bottombarLayer.frame = new Frame
		x : topBarLayer.x
		y : SCREEN_HEIGHT - TABBAR_HEIGHT
		width : containerLayer.width
		height : TABBAR_HEIGHT
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
	containerLayer = generateNormalLayer()
	
	containerLayer.image = background
		
	tempLayer = new Layer
		x : 0
		y : 0
		width : SCREEN_WIDTH
		height : 1037
	tempLayer.image = background
	tempLayer.scrollVertical = true
	if bottom == null
		tempLayer.height = SCREEN_HEIGHT
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
		y : TOPBAR_HEIGHT
		width : tempLayer.width
		height : 910
	tempLayer.addSubLayer contentLayer
	
	topBarLayer = new Layer
	topBarLayer.image = topbar
	topBarLayer.frame = new Frame
		x : 0
		y : 0
		width : tempLayer.width
		height : TOPBAR_HEIGHT
	containerLayer.addSubLayer topBarLayer
		
	if bottom != null
		bottombarLayer = new Layer
		bottombarLayer.image = bottom 
		bottombarLayer.frame = new Frame
			x : topBarLayer.x
			y : contentLayer.y + contentLayer.height
			width : tempLayer.width
			height : TABBAR_HEIGHT
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
	if contentHeight > SCREEN_HEIGHT
		return generateScrollableFullScreenLayer(background, topbar, content, bottom, logo, contentHeight)
	else 
		return generateDragableFullScreenLayer(background, topbar, content, bottom, logo, contentHeight)
	
showLaunchView = () ->
	launchView = new Layer
		x: 0
		y: STATUSBAR_HEIGHT
		width: SCREEN_WIDTH
		height: SCREEN_HEIGHT
	launchView.image = "images/launch.jpg"

	setTimeout((->
		showMainFrameTabView()
		launchView.visible = false
		),5000)
		
showMainFrameTabView = () ->
	firstTab.visible = true
	firstTab.bringToFront()
	secondTab.visible = false
	thirdTab.visible = false
	fourTab.visible = false
	
showContactTabView = () ->
	firstTab.visible = false
	secondTab.visible = true
	secondTab.bringToFront()
	thirdTab.visible = false
	fourTab.visible = false

showFindFriendTabView = () ->
	firstTab.visible = false
	secondTab.visible = false
	thirdTab.visible = true
	thirdTab.bringToFront()
	fourTab.visible = false
	
showMoreTabView = () ->
	firstTab.visible = false
	secondTab.visible = false
	thirdTab.visible = false
	fourTab.visible = true
	fourTab.bringToFront()
	
pushViewController = (bottomView, clickCell, topView) ->
	if clickCell != null
		clickCell.backgroundColor = "#d9d9d9"
		clickCell.opacity = 0.8
	
	viewPage = topView
	topView.x = SCREEN_WIDTH
	
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

addCancelButton = (bottomView, clickCell, topView) ->
	cancelButton = new Layer
		x : 520
		y : 0
		width : 150
		height : 88
	topView.addSubLayer cancelButton
	
	cancelButton.on Events.Click, ->
		
		topView.animate
			properties:
				x: 0
				y: SCREEN_HEIGHT
			curve: "bezier-curve"
			time: 0.5
		
	topView.on Events.AnimationEnd, ->
		if topView.y >= SCREEN_HEIGHT
			topView.visible = false
	return cancelButton

addBackButton = (bottomView, clickCell, topView) ->
	backButton = new Layer
		x : 0
		y : 0
		width : 140
		height : 88
	makeLighterLayer(backButton)
	topView.addSubLayer backButton
	
	backButton.on Events.Click, ->
		
		topView.animate
			properties:
				x: SCREEN_WIDTH
				y: STATUSBAR_HEIGHT
			curve: "bezier-curve"
			time: 0.5
			
		bottomView.x = -20
		bottomView.animate
			properties:
				x: 0
				y: STATUSBAR_HEIGHT
		curve: "bezier-curve"
		time: 0.01
		
	topView.on Events.AnimationEnd, ->
		if topView.x >= SCREEN_WIDTH
			topView.visible = false
	return backButton

##京东导航栏的布局
addCenterDropListButton = (topView) ->
	centerDropListButton = new Layer
		x : 555
		y : 0
		width : 150
		height : 88
	
	topView.addSubLayer centerDropListButton
	makeLighterLayer(centerDropListView)
	centerDropListView = null
	centerDropListButton.on Events.Click, ->
		if centerDropListView == null
			centerDropListView = showCenterDropListView(topView, centerDropListButton)
		else
			centerDropListView.visible = !centerDropListView.visible
	return centerDropListButton

#显示中间下拉列表
showCenterDropListView = (bottomView, clickButton) ->
	centerDropListView = new Layer
		x : 0
		y : SCREEN_HEIGHT - 832
		width : 640
		height : 832
	centerDropListView.image  = "images/jingdong/detailpage/center_menu_list.jpg"
	bottomView.addSubLayer centerDropListView
	addJDHomePageButton(centerDropListView)
	addClassifyButton(centerDropListView)
	addWishListButton(centerDropListView)
	addUserCenterButton(centerDropListView)
	addAllOrderButton(centerDropListView)
	addShoppingButton(centerDropListView)
	addCancelCenterDropListViewButton(centerDropListView)
	return centerDropListView

# 取消下拉菜单按钮 
addCancelCenterDropListViewButton = (topView) ->
	cancelButton = new Layer
		x : 40
		y : 720
		width : 560
		height : 88
	makeLighterLayer(cancelButton)
	topView.addSubLayer cancelButton
	cancelButton.on Events.Click, ->
		topView.visible = false
		
	return cancelButton
		
# 增加购物车的按钮
addShopCardButton = (topView) ->
	return null

#显示购物车页面
showShopCardView = (bottomView, clickButton) ->
	shopCardView = generateNormalLayer()
	shopCardView.image = "images/jingdong/detailpage/shopcard.jpg"
	changePageAnimation(bottomView, clickButton, shopCardView)
	addBackButton(bottomView, clickButton, shopCardView)
	addSearchButton(shopCardView)
	addCenterDropListButton(shopCardView)
	return showShopCardView

#增加搜索的按钮
addSearchButton = (topView) ->
	searchButton = new Layer
		x : 468
		y : 0
		width : 60
		height : 88

	topView.addSubLayer searchButton
	makeLighterLayer(searchButton)
	searchButton.on Events.Click, ->
		showSearchView(topView, searchButton)
	return searchButton

#显示搜索页面
showSearchView = (bottomView, clickButton) ->
	searchView = generateNormalLayer()
	searchView.image = "images/jingdong/detailpage/search_homepage.jpg"

	addCancelButton(bottomView, clickButton, searchView)
	addSearchContentButton(searchView)
	
	searchView.y = SCREEN_HEIGHT
	searchView.animate
	    properties:
	      x: 0
	      y: STATUSBAR_HEIGHT
	    curve: "bezier-curve"
	    time: 0.5
			delay: 0.1
	return searchView

#显示主界面按钮
addJDHomePageButton = (topView) ->
	jdHomePageButton = new Layer
		x : 60
		y : 70
		width : 114
		height : 114
	makeLighterLayer(jdHomePageButton)
	topView.addSubLayer jdHomePageButton
	jdHomePageButton.on Events.Click, ->
		showJDHomePageView(topView.superLayer, jdHomePageButton)
		topView.visible = false
		
	return jdHomePageButton
		
#显示主页
showJDHomePageView = (bottomView, clickButton) ->
	jdHomePageView = generateScrollableFullScreenLayer("images/gray_background.jpg",
			    "images/jingdong/homepage/homepage_topbar.png",
				"images/jingdong/homepage/homepage_content.jpg",
				null, null, 1529)
	changePageAnimation(bottomView, clickButton, jdHomePageView)
	backButton = new Layer
		x : 0
		y : 0
		width : 140
		height : 88
	jdHomePageView.addSubLayer backButton
	backButton.on Events.Click, ->
		changePageAnimationL2R(jdHomePageView, clickButton, thirdTab)
		
	jdHomePageView.on Events.AnimationEnd, ->
		if jdHomePageView.x >= SCREEN_WIDTH
			jdHomePageView.visible = false
			
	addCenterDropListButton(jdHomePageView)
	addSearchButton(jdHomePageView)
	addShopCardButton(jdHomePageView)
	addJDDetailPageButton(jdHomePageView)
	addCompareButton(jdHomePageView)
	addWishlistButton(jdHomePageView)
	addStreetShoppingButton(jdHomePageView)
	return showJDHomePageView

#街道导航Button
addStreetShoppingButton = (topView) ->
	streetShoppingButton = new Layer
		x : 20
		y : 500
		width : 600
		height : 140
	makeLighterLayer(streetShoppingButton)
	topView.addSubLayer streetShoppingButton
	streetShoppingButton.on Events.Click, ->
		showJDStreetPageView(topView, streetShoppingButton);
	return streetShoppingButton
	
#显示街道导航页面
showJDStreetPageView = (bottomView, clickButton) ->
	jdDetailPageView = generateScrollableFullScreenLayerImpl("images/gray_background.jpg", 
			    "images/jingdong/street/street_girl_topbar.jpg",
				"images/jingdong/street/street_girl_content.jpg",
				"images/jingdong/street/street_girl_bottombar.jpg", null, 888, false)
	changePageAnimation(bottomView, clickButton, jdDetailPageView)
	addJDDetailHeader(bottomView, clickButton, jdDetailPageView)
	return jdDetailPageView
	
# 比一比Button
addCompareButton = (topView) ->
	compareButton = new Layer
		x : 20
		y : 340
		width : 300
		height : 120
	makeLighterLayer(compareButton)
	topView.addSubLayer compareButton
	compareButton.on Events.Click, ->
		showJDComparePageView(topView, compareButton);
	return compareButton
	
# 比一比页
showJDComparePageView = (bottomView, clickButton) ->
	jdDetailPageView = generateScrollableFullScreenLayerImpl("images/gray_background.jpg", 
			    "images/jingdong/compare/compare_item_topbar.jpg",
				"images/jingdong/compare/compare_item_content.jpg",
				null, null, 1017, false)
	changePageAnimation(bottomView, clickButton, jdDetailPageView)
	addJDDetailHeader(bottomView, clickButton, jdDetailPageView)
	return jdDetailPageView
	
	
#心愿单Button
addWishlistButton = (topView) ->
	wishButton = new Layer
		x : 330
		y : 340
		width : 300
		height : 120
	makeLighterLayer(wishButton)
	topView.addSubLayer wishButton
	wishButton.on Events.Click, ->
		showWishListView(topView, wishButton)
	return wishButton
	
#分类导航的Button
addClassifyButton = (topView) ->
	classifyButton = new Layer
		x : 260
		y : 70
		width : 114
		height : 114
	makeLighterLayer(classifyButton)
	topView.addSubLayer classifyButton
	classifyButton.on Events.Click, ->
		showClassifyHomePageView(topView.superLayer, classifyButton)
		topView.visible = false
		
	return classifyButton

#显示分类主界面
showClassifyHomePageView = (bottomView, clickButton) ->
	classifyHomePageView = generateNormalLayer()
	classifyHomePageView.image = "images/jingdong/detailpage/classify_page.jpg"
	changePageAnimation(bottomView, clickButton, classifyHomePageView)
	addJDDetailHeader(bottomView, clickButton, classifyHomePageView)
	return classifyHomePageView

#显示心愿单的按钮
addWishListButton = (topView) -> 
	wishListButton = new Layer
		x : 470
		y : 70
		width : 114
		height : 114
	makeLighterLayer(wishListButton)
	topView.addSubLayer wishListButton
	wishListButton.on Events.Click, ->
		showWishListView(topView.superLayer, wishListButton)
		topView.visible = false
	return wishListButton

#显示心愿列表
showWishListView = (bottomView, clickButton) ->
	wishListView = generateNormalLayer()
	wishListView.image = "images/jingdong/detailpage/wish_list.jpg"
	changePageAnimation(bottomView, clickButton, wishListView)
	addJDDetailHeader(bottomView, clickButton, wishListView)
	addWishListFocusButton(wishListView)
	return wishListView
	
#显示关注心愿列表按钮
addWishListFocusButton = (topView) ->
	wishListFocusButton = new Layer
		x : 10
		y : 393
		width : 300
		height : 360
	makeLighterLayer(wishListFocusButton)
	topView.addSubLayer wishListFocusButton
	wishListFocusButton.on Events.Click, ->
		showWishListFocusView(topView.superLayer)
		topView.visible = false
		
	return wishListFocusButton

#显示关注心愿列表
showWishListFocusView = (bottomView, clickButton) ->
	wishListFocusView = generateNormalLayer()
	wishListFocusView.image = "images/jingdong/detailpage/wish_list_focus.jpg"

	addBackButton(bottomView, clickButton, wishListFocusView)
	addShopCardButton(wishListFocusView)
	addSearchButton(wishListFocusView)
	changePageAnimation(bottomView, clickButton, wishListFocusView)
	return wishListFocusView

#显示个人中心按钮
addUserCenterButton = (topView) ->
	userCenterButton = new Layer
			x : 260
			y : 270
			width : 114
			height : 114
	makeLighterLayer(userCenterButton)
	topView.addSubLayer userCenterButton
	userCenterButton.on Events.Click, ->
		showUserCenterView(topView.superLayer, userCenterButton)
		topView.visible = false
		
	return userCenterButton
			
#显示个人中心
showUserCenterView = (bottomView, clickButton) ->
	userCenterView = generateNormalLayer()
	userCenterView.image = "images/jingdong/detailpage/user_center.jpg"
	changePageAnimation(bottomView, clickButton, userCenterView)
	addJDDetailHeader(bottomView, clickButton, userCenterView)
	return userCenterView

#购物车按钮
addShoppingButton = (topView) ->
	shoppingButton = new Layer
		x : 60
		y : 270
		width : 114
		height : 114
	makeLighterLayer(shoppingButton)
	topView.addSubLayer shoppingButton
	shoppingButton.on Events.Click, ->
		showShopCardView(topView.superLayer, shoppingButton)
		topView.visible = false
		
	return shoppingButton

#显示全部订单按钮
addAllOrderButton = (topView) ->
	allOrderButton = new Layer
		x : 470
		y : 270
		width : 114
		height : 114
	makeLighterLayer(allOrderButton)
	topView.addSubLayer allOrderButton
	allOrderButton.on Events.Click, ->
		showAllOrderView(topView.superLayer)
		topView.visible = false
		
	return allOrderButton

#显示全部订单页面
showAllOrderView = (bottomView, clickButton) ->
	allOrderView = generateNormalLayer()
	allOrderView.image = "images/jingdong/detailpage/all_order.jpg"
	changePageAnimation(bottomView, clickButton, allOrderView)
	addJDDetailHeader(bottomView, clickButton, allOrderView)
	return allOrderView

#增加详细页面进入的按钮
addJDDetailPageButton = (topView) ->
	jdDetailButton = new Layer
		x : 20
		y : 660
		width : 300
		height : 415
	makeLighterLayer(jdDetailButton)
	topView.addSubLayer jdDetailButton
	jdDetailButton.on Events.Click, ->
		showJDDetailPageView(topView, jdDetailButton);
	return jdDetailButton

#显示京东详细页面
showJDDetailPageView = (bottomView, clickButton) ->
	jdDetailPageView = generateScrollableFullScreenLayerImpl("images/gray_background.jpg", 
			    "images/jingdong/detailpage/product_topbar.jpg",
				"images/jingdong/detailpage/product_content.jpg",
				"images/jingdong/detailpage/product_bottombar.jpg", null, 1531, false)
	changePageAnimation(bottomView, clickButton, jdDetailPageView)
	addJDDetailHeader(bottomView, clickButton, jdDetailPageView)
	addBuyButton(jdDetailPageView)
	addAddToShopCardButton(jdDetailPageView)
	addSatisfyWishButton(jdDetailPageView)
	return jdDetailPageView
	
#增加购买的按钮
addBuyButton = (topView) ->
	buyButton = new Layer 
			x : 12
			y : SCREEN_HEIGHT - 88
			width : 210
			height : 78
	makeLighterLayer(buyButton)
	topView.addSubLayer buyButton
	buyButton.on Events.Click, ->
		showProductSKUView(topView, buyButton)
	return buyButton

#显示商品详细页面
showProductSKUView = (bottomView, clickButton) ->
	productSkuView = generateNormalLayer()
	productSkuView.image = "images/jingdong/detailpage/product_sku.jpg"
	changePageAnimation(bottomView, clickButton, productSkuView)
	addJDDetailHeader(bottomView, clickButton, productSkuView)
	addConfirmButton(productSkuView)
	return productSkuView;
	
#增加确认按钮
addConfirmButton = (topView) ->
	confirmButton = new Layer
		x : 160
		y : SCREEN_HEIGHT - 120
		width : 350
		height : 84
	makeLighterLayer(confirmButton)
	topView.addSubLayer confirmButton
	confirmButton.on Events.Click, ->
		showPayView(topView, confirmButton)
	return confirmButton
	
#显示确认界面
showPayView = (bottomView, clickButton) ->
	payView  = generateNormalLayer()
	payView.image = "images/jingdong/detailpage/product_pay.jpg"
	changePageAnimation(bottomView, clickButton, payView)
	addJDDetailHeader(bottomView, clickButton, payView)
	return payView
	
#加入购物车按钮
addAddToShopCardButton = (topView) ->
	addToShopCardButton = new Layer 
		x : 230
		y : SCREEN_HEIGHT - 88
		width : 200
		height : 78
	makeLighterLayer(addToShopCardButton)
	topView.addSubLayer addToShopCardButton
	addToShopCardButton.on Events.Click, ->
		showShopCardView(topView, addToShopCardButton)

#显示第一次的引导页面
showFirstSnapshotView = (bottomView, clickButton) ->
	firstSnapshotView = generateNormalLayer()
	firstSnapshotView.image = "images/jingdong/homepage/firsttime_homepage.jpg"
	changePageAnimation(bottomView, clickButton, firstSnapshotView)
	enterButton = new Layer
			x : (SCREEN_WIDTH - 240)/2.0
			y : SCREEN_HEIGHT - 110 - 50
			width : 240
			height : 50
	makeLighterLayer(enterButton)
	firstSnapshotView.addSubLayer enterButton
	enterButton.on Events.Click, ->
		showJDHomePageView(firstSnapshotView, enterButton)
	addJDDetailHeader(bottomView, clickButton, firstSnapshotView)
	
	firstSnapshotView.on Events.AnimationEnd, ->
		if firstSnapshotView.x >= SCREEN_WIDTH
			firstSnapshotView.visible = false
			
	return firstSnapshotView;

#增加满足心愿按钮
addSatisfyWishButton = (topView) ->
	satisfyWishButton = new Layer
		x : 410
		y : 100
		width : 220
		height : 70
	makeLighterLayer(satisfyWishButton)
	topView.addSubLayer satisfyWishButton
	satisfyWishButton.on Events.Click, ->
		showSatisfyWishView(topView, satisfyWishButton)
	return satisfyWishButton

#满足心愿页面
showSatisfyWishView = (bottomView, clickButton) ->
	satisfyWishView = generateNormalLayer()
	satisfyWishView.image = "images/jingdong/detailpage/satisfy_wish.jpg"
	changePageAnimation(bottomView, clickButton, satisfyWishView)
	addJDDetailHeader(bottomView, clickButton, satisfyWishView)
	return satisfyWishView;

#展示搜索内容
addSearchContentButton = (topView) ->
	searchContentButton = new Layer
		x : 20
		y : 2
		width : 490
		height : 88
	topView.addSubLayer searchContentButton
	searchContentButton.on Events.Click, ->
		topView.image = "images/jingdong/detailpage/search_content.png"

#搜索内容页面
showSearchContentView = (bottomView, clickButton) ->
	searchContentView = generateNormalLayer()
	searchContentView.image = "images/jingdong/detailpage/search_content.png"
	changePageAnimation(bottomView, clickButton, searchContentView)
	backButton = addBackButton(bottomView, clickButton, searchContentView)
	backButton.x = 520
	backButton.width = 120
	return searchContentView;
	

# add jingdong detail header
addJDDetailHeader = (bottomView, clickButton, topView) ->
	addBackButton(bottomView, clickButton, topView)
	addCenterDropListButton(topView)
	addShopCardButton(topView)
	addSearchButton(topView)

#右到左的动画
changePageAnimation = (bottomView, clickButton, topView) ->
	viewPage = topView
	topView.x = SCREEN_WIDTH
	
	viewPage.animate
	    properties:
	      x: 0
	      y: STATUSBAR_HEIGHT
	    curve: "bezier-curve"
	    time: 0.5
		delay: 0.1
			
	bottomView.animate
		properties:
			x: -160
			y: STATUSBAR_HEIGHT
		curve: "bezier-curve"
		time: 0.5
		delay: 0.1
	topView.bringToFront()

#左到有的动画
changePageAnimationL2R = (bottomView, clickButton, topView) ->
	viewPage = topView
	topView.x = -160
	viewPage.animate
	    properties:
	      x: 0
	      y: STATUSBAR_HEIGHT
	    curve: "bezier-curve"
	    time: 0.5
		delay: 0.1
	bottomView.animate
		properties:
			x: SCREEN_WIDTH
			y: STATUSBAR_HEIGHT
		curve: "bezier-curve"
		time: 0.5
		delay: 0.1
	topView.placeBehind(bottomView)


pushJingdongHomepage = (clickCell) ->
	if thirdTab.name == "firsttime_homepage"
		showFirstSnapshotView(thirdTab)
		thirdTab.name = null
	else 
		showJDHomePageView(thirdTab)


addSpecialEventForFindFriend = () ->
	shoppingLayer = new Layer
		x : 0
		y : thirdTab.height - 320 - TABBAR_HEIGHT - 88
		width : thirdTab.width
		height : 88
	makeLighterLayer(shoppingLayer)
	
	thirdTab.addSubLayer shoppingLayer
	shoppingLayer.on Events.Click, ->
		pushJingdongHomepage(shoppingLayer)

firstTab = generateFullScreenLayer("images/black_background.png", 		"images/mainframe/mainframe_topbar.jpg",
"images/mainframe/mainframe_content.jpg",
"images/mainframe/mainframe_bottombar.jpg",
"images/mainframe/mainframe_logo.png",
1500)
firstTab.visible = false

secondTab = generateFullScreenLayer("images/black_background.png", 		"images/contactview/contactview_topbar.jpg", "images/contactview/contactview_content.jpg", "images/contactview/contactview_bottombar.jpg",
null,
1189)
secondTab.visible = false

thirdTab = generateFullScreenLayer("images/gray_background.jpg", 		"images/findfriend/findfriend_topbar.jpg", "images/findfriend/findfriend_content.jpg", "images/findfriend/findfriend_bottombar.jpg",
null,
910)
thirdTab.visible = false

thirdTab.name = "firsttime_homepage"
addSpecialEventForFindFriend()

fourTab = generateFullScreenLayer("images/gray_background.jpg", 		"images/moreview/moreview_topbar.jpg",
"images/moreview/moreview_content.jpg", "images/moreview/moreview_bottombar.jpg",
null,
910)
fourTab.visible = false

showLaunchView()



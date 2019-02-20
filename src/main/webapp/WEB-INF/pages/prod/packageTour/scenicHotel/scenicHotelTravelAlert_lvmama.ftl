<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>

<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/ui-common.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/ui-components.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/iframe.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/dialog.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/easyui.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/button.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/base.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/normalize.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/calendar.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/jquery.jsonSuggest.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/jquery.ui.autocomplete.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/jquery.ui.theme.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/contentManage/kindEditorConf.css" type="text/css">


<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/icons.css,/styles/lv/tips.css" type="text/css">
<script type="text/javascript" src="/vst_admin/js/prod/packageTour/scenicHotelTravelAlert.js?v1"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>

<style type="text/css">

.nova-tip-form{
	padding: 5px 0px 0px 19px;
}

body > div {
	padding:0 20px 10px 20px;
}

.newDivIndicator {
    float: right;
    right: 0px;
    top: -10px;
    position: absolute;
}

.newDivIndicator img{
width: 75px; 
height: 50px; 
transform:rotate(180deg);
}

.newDivIndicator span{
display:inline-block;
position:absolute;
left:45px;
top:5px;
color:#ffffff;
}

.ticketGoodsIndicator {
	border-top:1px solid #cccccc;
	padding-top:10px;
	margin-right:20px;
}


div.other,div.supplement {
	margin-top:10px;
}

body > h1 {
	margin : 5px 0;
	padding: 0 20px;
}
.s_mt1 {
	margin: 10px 20px;
	padding:10px 0px 10px 20px;
	border:1px solid #cccccc;
	width:80%;
	display:inline-block;
	position:  relative;
}
.s_mt1 > div {
	margin-top: 10px;
}
.s_mt1 > div > span.label {
	display: inline-block;
	width:100px;
	text-align:left;
}

.s_mt1 > div > input {
	width:65%;
}
.s_mt2 {
	margin-top: 10px;
	display:inline-block;
}
<#--
div.container {
 overflow:hidden;
}-->
div.other > div {
	padding-left:20px;
	display:inline-block;
	width:100px;
}

textarea {
 resize: vertical;
 }
div.other > textarea {
	width:72%;
	height:80px;
}
.category_header{
	margin-top:20px;
	width:780px;
}
.category_header > a {
	float:right;
}
.category_header > span {
	font-weight:bold;
}

div.supplement > div {
	padding-left:20px;
	display:inline-block;
	width:100px;
}
div.supplement > div >span {
	font-weight:bold;
}
div.supplement > textarea {
	width:72%;
	height:80px;
}
.s_operate {
	margin-top:10px;
	width: 800px;
	text-align:center;
}
</style>

</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">自由行</a> &gt;</li>
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">修改产品条款</li>
        </ul>
</div>
<div>
<h1 style="display:inline-block">出行警示及说明：</h1>
<span style="color:red;">被打包的酒店和景点信息变动时，页面新增变动提示，点击保存即可同步被打包酒店和门票的最新信息！</span>
</div>
<form action="/vst_admin/scenicHotel/saveTravelAlert.do" method="POST" id="travelAlertForm">

<#--添加ProdProductDescription 相关信息 -->
<#if productDesc??>
	<input type="hidden" name="productDesc.prodDescId" value="${productDesc.prodDescId!''}" />
	<input type="hidden" name="productDesc.categoryId" value="${productDesc.categoryId!''}" />
	<input type="hidden" name="productDesc.productId" value="${productDesc.productId!''}" />
	<input type="hidden" name="productDesc.productType" value="${productDesc.productType!''}" />
	<input type="hidden" name="productDesc.contentType" value="${productDesc.contentType!''}" />
</#if>

<input type="hidden" name="modelVersion" value="${modelVersion!0}" />

<input type="hidden" name="embedFlag" value="${embedFlag}" />

<#if isSupplierPackaged>
<div class="category_header">
	<input type="checkbox" />
	<span>酒店信息：</span>
		<a href="#" class="btn btn_cc1 js_add_hotel"  index="0">增加一条</a>
</div>
<#else>
<div class="category_header">
	<span style="display:inline-block; margin-left:20px;">酒店信息：</span>
</div>
</#if>

<div class="container JS_container_hotel_div">
	<#if traveAlertVo?? && traveAlertVo.hotelList??>
	<#-- 处理已删除的项 -->
	<#assign my_index=-1/>
	<#list traveAlertVo.hotelList as hotel>
	<div class="s_mt1" >
		<#assign isNewBlock = traveAlertVo.stateMap['HOTEL_' + hotel.id] == '1'/>
		<#assign isRemovedBlock = traveAlertVo.stateMap['HOTEL_' + hotel.id] == '2'/>
		<#if isNewBlock>
		<div class="newDivIndicator">
			<img src="/vst_admin/img/u1005.png" />
			<span>新增</span>
		</div>
		</#if>
		<#if isRemovedBlock>
			<div class="newDivIndicator">
				<img src="/vst_admin/img/u1005.png" />
				<span>已删</span>
			</div>
		<#else>
			<#assign my_index=my_index + 1/>
		</#if>
		<div>
			<span class="label">酒店名称：</span>
			<input type="hidden" <#if !isRemovedBlock>name="travelAlert.hotelList[${my_index}].id"</#if> value="${hotel.id!''}"/>
			<input type="text" class="s_1" 
				<#if !isRemovedBlock>name="travelAlert.hotelList[${my_index}].name" </#if>
				value="${hotel.name!''}" <#if !isSupplierPackaged> readonly="readonly"</#if>/>
			<#assign isFieldModified = hotel.state['name']/>
			<#if !isNewBlock && isFieldModified == 'Y'>
			<span class="nova-tip-form">
				<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             </span>
             </#if>
		</div>
		<div>
			<span class="label">酒店地址：</span>
			<input type="text" class="s_1" 
				<#if !isRemovedBlock>name="travelAlert.hotelList[${my_index}].address"</#if> 
				value="${hotel.address!''}" <#if !isSupplierPackaged> readonly="readonly"</#if> />
			<#assign isFieldModified = hotel.state['address']/>
			<#if !isNewBlock && isFieldModified == 'Y'>
			<span class="nova-tip-form">
				<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             </span>
             </#if>
		</div>
		<div>
			<span class="label">前台电话：</span>
			<input type="text" class="s_1" 
				<#if !isRemovedBlock>name="travelAlert.hotelList[${my_index}].phone"</#if> 
				value="${hotel.phone!''}" <#if !isSupplierPackaged> readonly="readonly"</#if>/>
			<#assign isFieldModified = hotel.state['phone']/>
			<#if !isNewBlock && isFieldModified == 'Y'>
			<span class="nova-tip-form">
				<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             </span>
             </#if>
		</div>
		<div>
			<span class="label">最早到店时间：</span>
			<input type="text" class="s_1" 
				<#if !isRemovedBlock>name="travelAlert.hotelList[${my_index}].arriveTime"</#if> 
				value="${hotel.arriveTime!''}" <#if !isSupplierPackaged> readonly="readonly"</#if>/>
			<#assign isFieldModified = hotel.state['arriveTime']/>
			<#if !isNewBlock && isFieldModified == 'Y'>
			<span class="nova-tip-form">
				<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             </span>
             </#if>
		</div>
		<div>
			<span class="label">最晚离店时间：</span>
			<input type="text" class="s_1" 
				<#if !isRemovedBlock>name="travelAlert.hotelList[${my_index}].leaveTime"</#if> 
				value="${hotel.leaveTime!''}" <#if !isSupplierPackaged> readonly="readonly"</#if>/>
			<#assign isFieldModified = hotel.state['leaveTime']/>
			<#if !isNewBlock && isFieldModified == 'Y'>
			<span class="nova-tip-form">
				<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             </span>
             </#if>
		</div>
		<div>
			<span class="label">入住方式：</span>
			<input type="text" class="s_1" 
				<#if !isRemovedBlock>name="travelAlert.hotelList[${my_index}].checkinStyle"</#if> 
				value="${hotel.checkinStyle!''}"/>
			<#assign isFieldModified = hotel.state['checkinStyle']/>
			<#if !isNewBlock && isFieldModified == 'Y'>
			<span class="nova-tip-form">
				<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             </span>
             </#if>
		</div>
	</div>
	</#list>
	</#if>
	
	<#if isSupplierPackaged>
	<div class="s_mt2">
		<a href="#" class="btn btn_cc1">删除</a>
	</div>
	</#if>
</div>
<div class="other">
	<div>
		<input type="checkbox" class="js_switcher"  <#if traveAlertVo.hotelExtra??>checked</#if>/>
		<span>其他：</span>
	</div>
	<textarea name="travelAlert.hotelExtra" <#if !(traveAlertVo.hotelExtra??)>disabled</#if> >${traveAlertVo.hotelExtra!''}</textarea>
</div>

<!--ticket-->
<#if isSupplierPackaged>
<div class="category_header">
	<input type="checkbox" />
	<span>景点门票信息：</span>
	<a href="#" class="btn btn_cc1 js_add_ticket" index="0">增加一条</a>
</div>
<#else>
<div class="category_header">
	<span style="display:inline-block; margin-left:20px;">景点门票信息：</span>
</div>
</#if>

<div class="container JS_container_ticket_div">
	<#if traveAlertVo?? && traveAlertVo.ticketList??>
	<#assign my_index=-1/>
	<#list traveAlertVo.ticketList as ticket>
		<#assign isNewBlock = traveAlertVo.stateMap['LINE_TICKET_' + ticket.id] == '1'/>
		<#assign isRemovedBlock = traveAlertVo.stateMap['LINE_TICKET_' + ticket.id] == '2'/>
		<#if ticket??>
		<div  class="s_mt1">
			<#if isNewBlock>
			<div class="newDivIndicator">
				<img src="/vst_admin/img/u1005.png" />
				<span>新增</span>
			</div>
			</#if>
			<#if isRemovedBlock>
			<div class="newDivIndicator">
				<img src="/vst_admin/img/u1005.png" />
				<span>已删</span>
			</div>
			<#else>
				<#assign my_index=my_index + 1/>
			</#if>
			<div>
				<span class="label">景点名称：</span>
				<input type="hidden" <#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].id"</#if> value="${ticket.id}"/>
				<input type="text" class="s_1" 
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].name" value="${ticket.name!''}"</#if> 
					<#if !isSupplierPackaged> readonly="readonly"</#if>/>
				<#assign isFieldModified = ticket.state['name']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span class="label">景点地址：</span>
				<input type="text" class="s_1"  
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].destName"</#if> 
					value="${ticket.destName!''}" <#if !isSupplierPackaged> readonly="readonly"</#if>/>
				<#assign isFieldModified = ticket.state['destName']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span class="label">免票政策：</span>
				<textarea  style="width:65%;height: 65px;"
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].freePolicy"</#if> 
					<#if !isSupplierPackaged>readonly="readonly"</#if> >${ticket.freePolicy!''}</textarea>
				<#assign isFieldModified = ticket.state['freePolicy']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span class="label">优惠政策：</span>
				<textarea style="width:65%;height: 65px;"
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].preferentialCrowd"</#if> 
					 <#if !isSupplierPackaged>readonly="readonly"</#if>/>${ticket.preferentialCrowd!''}</textarea>
				<#assign isFieldModified = ticket.state['preferentialCrowd']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span class="label">重要说明：</span>
				<textarea style="width:65%;height: 65px;"
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].bookDescription"</#if> 
					<#if !isSupplierPackaged>readonly="readonly"</#if>>${ticket.bookDescription!''}</textarea>
				<#assign isFieldModified = ticket.state['bookDescription']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			
			<#assign my_goods_index=-1/>
			<#list ticket.goodsList as ticketGoodsItem>
			<#-- 标识判断开始 -->
			<#assign isNewBlock = ticket.state['TICKET_GOODS_' + ticketGoodsItem.id] == '1'/>
			<#assign isRemovedBlock = isRemovedBlock || ticket.state['TICKET_GOODS_' + ticketGoodsItem.id] == '2'/>
			<div class="ticketGoodsIndicator" <#if isNewBlock || isRemovedBlock>style="position:  relative;" </#if>>
				<#if isNewBlock>
				<div class="newDivIndicator" style="right:-20px; top:0px;">
					<img src="/vst_admin/img/u1005.png" />
					<span>新增</span>
				</div>
				</#if>
				<#if isRemovedBlock>
					<div class="newDivIndicator"  style="right:-20px; top:0px;">
						<img src="/vst_admin/img/u1005.png" />
						<span>已删</span>
					</div>
				<#else>
					<#assign my_goods_index=my_goods_index + 1/>
				</#if>
			</div>
			<#-- 标识判断结束-->
			<div >
				<span class="label">门票名称：</span>
				<input type="hidden" <#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].goodsList[${my_goods_index}].id"</#if> value="${ticketGoodsItem.id!''}"/>
				<#assign isFieldModified = ticketGoodsItem.state['goodsName']/>
				<input type="text" class="s_1"  
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].goodsList[${my_goods_index}].name"</#if> 
					value="${ticketGoodsItem.name!''}" 
					<#if !isSupplierPackaged> readonly="readonly"</#if>/>
				<#assign isFieldModified = ticketGoodsItem.state['name']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span class="label">入园时间：</span>
				<input type="text" class="s_1" 
					<#if !isRemovedBlock> name="travelAlert.ticketList[${my_index}].goodsList[${my_goods_index}].limitTime"</#if> 
					value="${ticketGoodsItem.limitTime!''}"
					<#if !isSupplierPackaged> readonly="readonly"</#if> />
				<#assign isFieldModified = ticketGoodsItem.state['limitTime']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span  class="label">取票地点：</span>
				<input type="text" class="s_1"  
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].goodsList[${my_goods_index}].changeAddress"</#if> 
					value="${ticketGoodsItem.changeAddress!''}"
					<#if !isSupplierPackaged> readonly="readonly"</#if> />
				<#assign isFieldModified = ticketGoodsItem.state['changeAddress']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span  class="label">取票时间：</span>
				<input type="text" class="s_1"  
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].goodsList[${my_goods_index}].changeTime"</#if> 
					value="${ticketGoodsItem.changeTime!''}"
					<#if !isSupplierPackaged> readonly="readonly"</#if> />
				<#assign isFieldModified = ticketGoodsItem.state['changeTime']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span class="label">取票方式：</span>
				<input type="text" class="s_1"  
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].goodsList[${my_goods_index}].entryStyle"</#if> 
					value="${ticketGoodsItem.entryStyle!''}"
					<#if !isSupplierPackaged> readonly="readonly"</#if> />
				<#assign isFieldModified = ticketGoodsItem.state['entryStyle']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span class="label">有效期：</span>
				<input type="text" class="s_1"  
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].goodsList[${my_goods_index}].expireDays"</#if> 
					value="${ticketGoodsItem.expireDays!''}"
					<#if !isSupplierPackaged> readonly="readonly"</#if> />
				<#assign isFieldModified = ticketGoodsItem.state['expireDays']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
             	</span>
             	</#if>
			</div>
			<div>
				<span class="label">重要提示：</span>
				<textarea  style="width:65%;height: 65px;" 
					<#if !isRemovedBlock>name="travelAlert.ticketList[${my_index}].goodsList[${my_goods_index}].importWarning" </#if>
					<#if !isSupplierPackaged> readonly="readonly"</#if> />${ticketGoodsItem.importWarning!''}</textarea>
				<#assign isFieldModified = ticketGoodsItem.state['importWarning']/>
				<#if !isNewBlock && isFieldModified == 'Y'>
				<span class="nova-tip-form">
					<span class="nova-icon-xs nova-icon-warning"></span>信息被修改
            	</span>
            	</#if>
			</div>
			</#list>
		</div>
		</#if>
	</#list>
	</#if>
	
	<#if isSupplierPackaged>
	<a href="#" class="btn btn_cc1">删除</a>
	</#if>
</div>
<div class="other">
	<div>
		<input type="checkbox" class="js_switcher" <#if traveAlertVo.ticketExtra??>checked</#if>/>
		<span>其他：</span>
	</div>
	<textarea name="travelAlert.ticketExtra" <#if !(traveAlertVo.ticketExtra??)>disabled</#if> >${traveAlertVo.ticketExtra!''}</textarea>
</div>

<!--supplements-->
<div class="supplement">
	<div>
		<input type="checkbox" class="js_switcher" <#if traveAlertVo.supplements??>checked</#if>/>
		<span>补充：</span>
	</div>
	<textarea name="travelAlert.supplements" <#if !(traveAlertVo.supplements??)>disabled</#if>>${traveAlertVo.supplements!''}</textarea>
</div>

<#if embedFlag !="Y">
<div class="s_operate operate">
	<a href="javascript:void(0);" class="btn btn_cc1" id="save">保存</a>
	<a href="javascript:void(0);" class="btn btn_cc1" id="viewLog" 
		param="objectId=${productDesc.productId!0}&objectType=PROD_PRODUCT_SUGG&sysName=VST"
	>操作日志</a>
</div>
</#if>
</form>

<#if embedFlag !="Y">
<div style="height:200px;">
<div>
</#if>
</body>
</html>


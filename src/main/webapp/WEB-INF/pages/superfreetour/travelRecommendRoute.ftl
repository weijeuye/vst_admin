<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑行程</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/calendar.css,/styles/lv/buttons.css,/styles/lv/dialog.css,/styles/lv/icons.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/gallery/v1/reset.css,/styles/backstage/vst/gallery/v1/flat.css,/styles/backstage/vst/gallery/v1/gallery-backstage/display.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/gallery/v1/product-input/product-input-image-upload.css">
    <!-- 新添加-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst/gallery/v1/resources.css">
    <style>
        .ticket li {
            float: left;
            position: relative;
            margin-right: 10px;
        }
        .ticket li span {
            display: block;
            height: 30px;
            line-height: 30px;
            padding: 0 13px;
            cursor: pointer;
            font-size: 14px;
            color: #666;
            border: 1px solid #ccc;
        }
        .ticket li:hover .edit-delete-btn{
            display: block;
        }
    </style>
</head>
<body class="">

<div class="edit-manage">   
    <div class="step-two" style="display: block">
        <p  class="edit-step">编辑行程</p>
        <div class="edit-strategy-box">        	
            <div class="edit-strategy-day">
                <ul class="edit-day ">
                	<#if routeDetailList?? && routeDetailList?size gt 0>
                		<#assign index=0 />
						<#list routeDetailList as item>						
						 <li <#if index = 0>class="active"</#if> >
                             <span detailId="${(item.detailId)!''}">D${index+1}</span>
                             <i class="edit-delete-btn nova-icon-xs nova-icon-error" detailId="${(item.detailId)!''}" ></i>
							<#assign index=index+1 />
						</li>
						</#list>
					<#else>
                    	<li class="active">
                        	<span >D1</span>
                        	<i class="edit-delete-btn nova-icon-xs nova-icon-error" ></i>
                    	</li>
                    </#if>
                </ul>
                <a class="btn add-edit-day">+ 新增行程天数</a>
            </div>
            
            <input type="hidden" id="recommendId" value="${recommendId}">
            <div class="js-detail-box">
            	<form method="post" >
                <#--  某一天行程从这里开始，这个div需要绑定数据 -->
                <#if routeDetailList?? && routeDetailList?size gt 0>
                    <#-- 这里只取第一天的数据，第一天是随页面ftl直接加载的，之后都是ajax通过json数据加载的 -->
                    <#list routeDetailList as item>
                        <#if item_index = 0>
                            <div class="main js-day-detail" data-day="1" data-detailId="${(item.detailId)!''}">
                        </#if>
                    </#list>
                <#else >
                    <div class="main js-day-detail" data-day="1" data-detailId="">
                </#if>
                    <dl class="cf">
                        <dt>
                            <i class="red">*</i>标题
                        </dt>
                        <dd>
                        	<#if routeDetail??>
                            	<input type="text" name="routeTitle" value="${routeDetail.routeTitle}" class="flat-input flat-input-long flat-width detail-title" maxlength="25">
                            <#else>
                            	<input type="text" name="routeTitle" class="flat-input flat-input-long flat-width detail-title" placeholder="请输入该天行程标题（1-25字符）" maxlength="25">
                            </#if>
                        </dd>
                    </dl>
                    <div class="strategy-detail">                    
                    <#if detailGroupList?? && detailGroupList?size gt 0>
                    	<#assign index=0 />
						<#list detailGroupList as item>						
        					<input type="hidden" id="groupId" value="${item.groupId}">
        					<input type="hidden" name="detailGroupList[${index}].propSort" value="${index}"/>
                        <div class="js-detail">
                            <dl class="cf">
                                <dt>
                                    <i class="red">*</i>明细<span class="edit-sort">1</span>
                                </dt>
                                <dd>
                                    <select name="detailGroupList[${index}].propType" class="form-control require-con require-con-box" data-tag="itemType">
                                        <option value="VEHICLE" <#if item.propType == 'VEHICLE'>selected</#if> >交通</option>
                                        <option value="HOTEL" <#if item.propType == 'HOTEL'>selected</#if> >住宿</option>
                                        <option value="SCENE" <#if item.propType == 'SCENE'>selected</#if> >景点</option>
                                        <option value="MEAL" <#if item.propType == 'MEAL'>selected</#if> >用餐</option>
                                        <option value="SHOPPING" <#if item.propType == 'SHOPPING'>selected</#if> >购物点</option>
                                        <option value="ACTIVITY" <#if item.propType == 'ACTIVITY'>selected</#if> >自由活动</option>
                                        <option value="RECOMMEND" <#if item.propType == 'RECOMMEND'>selected</#if> >推荐项目</option>
                                        <option value="OTHER" <#if item.propType == 'OTHER'>selected</#if> >其他活动</option>
                                        <option value="DELETE">无</option>
                                    </select>
                                    <select name="detailGroupList[${index}].propName" class="form-control require-con require-con-box" data-tag="itemTypeDetail">
                                        <option value="机票">机票</option>
                                        <option value="火车票">火车票</option>
                                        <option value="巴士">巴士</option>
                                        <option value="交通接驳">交通接驳</option>
                                    </select>
                                </dd>
                            </dl>
                            <dl class="cf">
                                <dt><i class="red">*</i>正文</dt>
                                <dd>
                                    <textarea name="detailGroupList[${index}].propValue" maxlength="500" class="edit-tips" placeholder="最多500字哦~">${item.propValue!''}</textarea>
                                </dd>
                            </dl>
                            <dl class="cf">
                                <dt>图片</dt>
                                <dd>
                                    <ul class="upload-add-image-ul">
                                        <li class="last-add-image js-add-image" data-tag='addimg'>
                                            <a href="javascript:;"><i class="last-add-image-btn"></i>最多可上传6张图片</a>
                                        </li>
                                        <#if item.photoUrlList?? && item.photoUrlList?size gt 0>
                                            <#list item.photoUrlList as photoItem>
                                                <li class="edit-add-pic" data-pic="${photoItem}">
                                                    <img src="http://pic.lvmama.com/${photoItem}" width="210" height="140"/>
                                                    <div class="upload-item-mask"></div>
                                                    <div class="upload-item-delete JS-upload-item-delete"><i></i></div>
                                                </li>
                                            </#list>
                                        </#if>
                                    </ul>
                                </dd>
                            </dl>
                            <#if item_has_next>
                                <a class="btn js-delete-detail" >删除</a>
                                <a class="btn add-detail js-add-detail" style="display: none">+ 新增明细</a>
                            <#else>
                                <a class="btn js-delete-detail" style="display: none">删除</a>
                                <a class="btn add-detail js-add-detail">+ 新增明细</a>
                            </#if>
                        </div>
                        	<#assign index=index+1 />
                        </#list>
                        
					<#else>
						<#assign index=0 />
						<div class="js-detail">
                            <dl class="cf">
                                <dt>
                                    <i class="red">*</i>明细<span class="edit-sort">1</span>
                                </dt>
                                <dd>
                                    <select name="detailGroupList[${index}].propType" class="form-control require-con require-con-box" data-tag="itemType">
                                        <option value="VEHICLE" >交通</option>
                                        <option value="HOTEL" >住宿</option>
                                        <option value="SCENE" >景点</option>
                                        <option value="MEAL" >用餐</option>
                                        <option value="SHOPPING" >购物点</option>
                                        <option value="ACTIVITY">自由活动</option>
                                        <option value="RECOMMEND">推荐项目</option>
                                        <option value="OTHER">其他活动</option>
                                        <option value="DELETE">无</option>
                                    </select>
                                    <select name="detailGroupList[${index}].propName" class="form-control require-con require-con-box" data-tag="itemTypeDetail">
                                        <option value="机票">机票</option>
                                        <option value="火车票">火车票</option>
                                        <option value="巴士">巴士</option>
                                        <option value="交通接驳">交通接驳</option>
                                    </select>
                                </dd>
                            </dl>
                            <dl class="cf">
                                <dt><i class="red">*</i>正文</dt>
                                <dd>
                                    <textarea name="detailGroupList[${index}].propValue" maxlength="500" class="edit-tips" placeholder="最多500字哦~"></textarea>
                                </dd>
                            </dl>
                            <dl class="cf">
                                <dt>图片</dt>
                                <dd>
                                    <ul class="upload-add-image-ul">
                                        <li class="last-add-image js-add-image" data-tag='addimg'>
                                            <a href="javascript:;"><i class="last-add-image-btn"></i>最多可上传6张图片</a>
                                        </li>
                                    </ul>
                                </dd>
                            </dl>
                            <a class="btn js-delete-detail" style="display: none">删除</a>
                            <a class="btn add-detail js-add-detail">+ 新增明细</a>
                        </div>	
                        				
					</#if>
                    </div>                    
                    <a class="btn btn-blue strategy-save-btn">保存行程</a>
                </div>
                </form>
            </div>

        </div>
    </div>
</div>

<!--模板-->
<div class="edit-template" style="display: none">
    <!-- 新增图片 -->
    <li class="edit-add-pic">
        <img src="http://placehold.it/210x140/d9d9d9" width="210" height="140"/>
        <div class="upload-item-mask"></div>
        <div class="upload-item-delete JS-upload-item-delete"><i></i></div>
        <#--<div class="upload-item-cover">设为封面</div>-->
    </li>
    <!--新增明细 开始-->
    <div class="js-detail">
        <dl class="cf">
            <dt>
                <i class="red">*</i>明细<span class="edit-sort">1</span>
            </dt>
            <dd>
                <select class="form-control require-con require-con-box" data-tag="itemType">
                    <option value="VEHICLE" >交通</option>
                    <option value="HOTEL" >住宿</option>
                    <option value="SCENE" >景点</option>
                    <option value="MEAL" >用餐</option>
                    <option value="SHOPPING" >购物点</option>
                    <option value="ACTIVITY">自由活动</option>
                    <option value="RECOMMEND">推荐项目</option>
                    <option value="OTHER">其他活动</option>
                    <option value="DELETE">无</option>
                </select>
                <select class="form-control require-con require-con-box" data-tag="itemTypeDetail">
                    <option value="机票">机票</option>
                    <option value="火车票">火车票</option>
                    <option value="巴士">巴士</option>
                    <option value="交通接驳">交通接驳</option>
                </select>
            </dd>
        </dl>
        <dl class="cf">
            <dt><i class="red">*</i>正文</dt>
            <dd>
                <textarea maxlength="500" class="edit-tips" placeholder="最多500字哦~"></textarea>
            </dd>
        </dl>
        <dl class="cf">
            <dt>图片</dt>
            <dd>
                <ul class="upload-add-image-ul">
                    <li class="last-add-image js-add-image" data-tag='addimg'>
                        <a href="javascript:;"><i class="last-add-image-btn"></i>最多可上传6张图片</a>
                    </li>
                </ul>
            </dd>
        </dl>
        <a class="btn js-delete-detail" style="display: none;">删除</a>
        <a class="btn add-detail js-add-detail">+ 新增明细</a>
    </div>
    <!--新增明细 END-->
</div>
<!--新增天数内容 开始-->
<div class="template-detail" style="display: none">
    <div class="main js-day-detail"  style="display: none">
        <dl class="cf">
            <dt>
                <i class="red">*</i>标题
            </dt>
            <dd>
                <input type="text" name='routeTitle' class="flat-input flat-input-long flat-width" placeholder="请输入该天行程标题（1-25字符）" maxlength="25">
            </dd>
        </dl>
        <div class="strategy-detail">
            <div class="js-detail">
                <dl class="cf">
                    <dt>
                        <i class="red">*</i>明细<span class="edit-sort">1</span>
                    </dt>
                    <dd>
                        <select class="form-control require-con require-con-box" data-tag="itemType">
                            <option value="VEHICLE" >交通</option>
                            <option value="HOTEL" >住宿</option>
                            <option value="SCENE" >景点</option>
                            <option value="MEAL" >用餐</option>
                            <option value="SHOPPING" >购物点</option>
                            <option value="ACTIVITY">自由活动</option>
                            <option value="RECOMMEND">推荐项目</option>
                            <option value="OTHER">其他活动</option>
                            <option value="DELETE">无</option>
                        </select>
                        <select class="form-control require-con require-con-box" data-tag="itemTypeDetail">
                            <option value="机票">机票</option>
                            <option value="火车票">火车票</option>
                            <option value="巴士">巴士</option>
                            <option value="交通接驳">交通接驳</option>
                        </select>
                    </dd>
                </dl>
                <dl class="cf">
                    <dt><i class="red">*</i>正文</dt>
                    <dd>
                        <textarea maxlength="500" class="edit-tips" placeholder="最多500字哦~"></textarea>
                    </dd>
                </dl>
                <dl class="cf">
                    <dt>图片</dt>
                    <dd>
                        <ul class="upload-add-image-ul">
                            <li class="last-add-image js-add-image" data-tag='addimg'>
                                <a href="javascript:;"><i class="last-add-image-btn"></i>最多可上传6张图片</a>
                            </li>
                        </ul>
                    </dd>
                </dl>
                <a class="btn js-delete-detail" style="display: none">删除</a>
                <a class="btn add-detail js-add-detail">+ 新增明细</a>
            </div>
        </div>
        <a class="btn btn-blue strategy-save-btn">保存行程</a>
    </div>
</div>
<!--新增天数内容 END-->

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common.js,/js/lv/dialog.js,/js/lv/calendar.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/vst/gallery/v1/gallery-backstage/display.js"></script>
<script src="http://pic.lvmama.com/js/backstage/vst/gallery/v1/resources.js"></script>
<script>
    var pandora={
        dialog:{
            defaults:{}
        }
    };
</script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script>

    //下拉框关联明细
    var itemTypeData=[{
        id:"VEHICLE",
        data:["机票","火车票","巴士","交通接驳"]
    },{
        id:"HOTEL",
        data:["酒店","酒店套餐"]
    }];

    //弹框对象
    var uploadImgDialog;
    var selectTicketDialog;
    var $selectTicketSrc;
    var $uploadImgSrc;

    $(document).ready(function(){
        //关联下拉框
        $("select[data-tag='itemType']").live("change",function(){
            $(this).parent().find("div[data-tag='ticket']").remove();
            var selectType = $(this).val();
            if(selectType=="DELETE"){
                //需要删除
                var $thisParent = $(this).parents(".js-detail");
                var $daydiv = $(this).parents("div[data-day]");
                if($daydiv.find(".js-detail").length==1){
                    //仅剩下最后一个，先加一个出来再删除
                    $thisParent.find(".js-add-detail").eq(0).trigger("click");
                }
                $(this).parents(".js-detail").remove();
                //强制版面最后一个增加按钮显示
                $daydiv.find(".js-delete-detail:last").hide();
                $daydiv.find(".js-add-detail:last").show();
                sort();
                return;
            }
            var tempData = null;
            for(var i=0;i<itemTypeData.length;i++){
                if(itemTypeData[i].id==selectType){
                    tempData = itemTypeData[i].data;
                    break;
                }
            }
            if(tempData==null){
                //需要显示文本框
                var selectBox = $(this).parent().find("select[data-tag='itemTypeDetail']");
                if(selectBox.length>0){
                    //原本是下拉框
                    var name = selectBox.attr("name");
                    selectBox.eq(0).remove();
                    $(this).parent().append("<input name='"+name+"' type='text' data-tag='itemTypeDetail' style='width: 300px;' class='flat-input flat-input-long detail-title' placeholder='请输入明细内容' maxlength='50'  > ");
                }
                if(selectType=="SCENE"){
                    $(this).parent().append("<a data-tag='ticket' class='btn'>设置门票</a><div data-tag='ticket' style='    margin-top: 10px;'><span style='float: left;'>门票：</span><ul class='ticket'></ul></div>");
                }else{
                    $(this).parent().find("a[data-tag='ticket']").remove();
                }
            }else{
                //需要显示下拉框
                var input = $(this).parent().find("input[data-tag='itemTypeDetail']");
                $(this).parent().find("a[data-tag='ticket']").remove();
                if(input.length>0){
                    //原本是文本框
                    var name = input.attr("name");
                    input.eq(0).remove();
                    $(this).parent().append("<select name='"+name+"' class='form-control require-con require-con-box' data-tag='itemTypeDetail'> ");
                    //填充数据
                    var selectBox = $(this).parent().find("select[data-tag='itemTypeDetail']").eq(0);
                    for(var i=0;i<tempData.length;i++){
                        selectBox.append("<option value='"+tempData[i]+"'>"+tempData[i]+"</option>");
                    }
                }else{
                    //原本是下拉框，重新填写数据
                    var selectBox = $(this).parent().find("select[data-tag='itemTypeDetail']").eq(0);
                    selectBox.empty();
                    for(var i=0;i<tempData.length;i++){
                        selectBox.append("<option value='"+tempData[i]+"'>"+tempData[i]+"</option>");
                    }
                }
            }
        });

        //选择门票
        $("a[data-tag='ticket']").live("click",function(){
            $selectTicketSrc = $(this);
            var url = "/vst_admin/superfreetour/travelRecommendRoute/showSelectProductList.do?groupType=LINE_TICKET&selectParentCategoryFlag=Y&selectCategoryId=11&subCategoryId=181";
            selectTicketDialog=nova.dialog({
                url:true,
                content:url,
                width:1000,
                initHeight:1100,
                title:'选择门票',
                wrapClass:"upload-image-dialog"
            });
        });

        //删除门票
        $(".ticket .edit-delete-btn").live("click",function(){
           $(this).parent().remove();
        });

        //上传图片
        $("li[data-tag='addimg']").live("click",function(){
            $uploadImgSrc=$(this);
            var lilength = $uploadImgSrc.parent().find("li").length;
            if(lilength>=7){
                nova.alert("最多上传6张图片！");
                return false;
            }
//        测试使用
//        addImg("uploads/pc/place2/2017-06-16/f7bdd1cb-20fe-4320-a09b-198a93bcbd9b.jpg");
//        return;
            var url = "/photo-back/photo/photo/imgPlugIn.do?relationId=${recommendId}&relationType=1&imgLimitType=LIMIT_3_2_3L";
            uploadImgDialog=nova.dialog({
                url:true,
                content:url,
                width:838,
                initHeight:680,
                title:'上传图片',
                wrapClass:"upload-image-dialog"
            })
        });

        //第一天加载数据
        <#if detailGroupList?? && detailGroupList?size gt 0>
            <#list detailGroupList as item>
                initSelectBoxData(1,'itemType','${item.propType}',${item_index});
                initSelectBoxData(1,'itemTypeDetail','${item.propName}',${item_index});
                <#if item.ticketList?? && item.ticketList?size gt 0>
                    <#list item.ticketList as ticket>
                        initTicket(1,'${ticket.ticketId}','${ticket.ticketGoodsId}','${ticket.ticketName}','${ticket.ticketGoodsName}',${item_index});
                    </#list>
                </#if>
            </#list>
        </#if>
        sort();
        refreshSensitiveWord($("input[type='text'],textarea"));
    });

    //加载明细数据
    function initSelectBoxData(dayindex,boxtype,boxvalue,index){
        var $parentEl = $("div[data-day='"+dayindex+"']");
        var $jsdetailEl = $parentEl.find(".js-detail").eq(index);
        $jsdetailEl.find("[data-tag='"+boxtype+"']").val(boxvalue);
        $jsdetailEl.find("[data-tag='"+boxtype+"']").trigger("change");
    }

    //加载门票数据
    function initTicket(dayindex,ticketId,ticketGoodsId,ticketName,ticketGoodsName,index){
        var $parentEl = $("div[data-day='"+dayindex+"']");
        var $jsdetailEl = $parentEl.find(".js-detail").eq(index);
        if(ticketName && ticketName!=""){
            if(ticketGoodsName && ticketGoodsName!=""){
                ticketGoodsName="-"+ticketGoodsName;
            }else {
                ticketGoodsName="";
            }

        }else {
            if(ticketGoodsName && ticketGoodsName!=""){
                ticketGoodsName=ticketGoodsName;
            }else {
                ticketGoodsName="";
            }
        }
        $jsdetailEl.find("ul.ticket").append("<li data-ticketid='"+ticketId+"' data-ticketgoodid='"+ticketGoodsId+"'><span>"+ticketName+""+ticketGoodsName+"</span><i class='edit-delete-btn nova-icon-xs nova-icon-error'></i></li>");
    }

    //加载图片数据
    function createImg(dayindex,picurl,index){
        var $parentEl = $("div[data-day='"+dayindex+"']");
        var $tem = $(".edit-template").find(".edit-add-pic").clone();
        $parentEl.find("ul.upload-add-image-ul").eq(index).append($tem);
        $tem.find("img").attr("src","http://pic.lvmama.com/"+picurl);
        $tem.attr("data-pic",picurl);
        return true;
    }

    //选择门票的回调函数
    function selectTickCallBack(productData){
        var hasSelectedGoods=[];
        $selectTicketSrc.siblings("div[data-tag='ticket']").find(".ticket").find("li").each(function () {
            if($(this).attr("data-ticketgoodid") && $(this).attr("data-ticketgoodid")!=null){
                hasSelectedGoods.push($(this).attr("data-ticketgoodid"));
            }
        })
        if(productData!=null && productData.length > 0 && hasSelectedGoods.length >0){
            for(var i=0;i<hasSelectedGoods.length;i++){
                for(var j=productData.length-1;j >= 0;j--){
                    if(hasSelectedGoods[i]==productData[j].goodsId){
                        productData.splice(j,1);
                        break;
                    }
                }
            }
        }
        selectTicketDialog.close();
        if(productData!=null && productData.length>0){
            for (var i =0; i< productData.length;i++){
                $selectTicketSrc.parent().find("ul.ticket").append("<li data-ticketid='"+productData[i].productId+"' data-ticketGoodId='"+productData[i].goodsId+"'><span>"+productData[i].productName+"-"+productData[i].goodsName+"</span><i class='edit-delete-btn nova-icon-xs nova-icon-error'></i></li>");
            }
        }
    }

    //明细排序
    function sort() {
        $(".js-day-detail").each(function () {
            var $this = $(this);
            var $sort = $this.find(".edit-sort");
            for (var i=0;i<$sort.length;i++){
                $sort.eq(i).html(i+1);
            }
        });
    };


    $(function () {
        var $document = $(document);
        var $editTemplate = $(".edit-template");
        var $templateDetail = $(".template-detail");
        //新增行程准备
        $document.on("click",".js-add-trip",function () {
            var $this = $(this);
            var $tripBox = $this.parents(".add-trip");
            var $editTripBox = $this.parents(".add-trip-box");
            $this.hide();
            $tripBox.find(".trip-delete-btn").show();
            var $tem = $editTemplate.find(".add-trip").clone();
            $editTripBox.append($tem);
        });
        $document.on("click",".trip-delete-btn",function () {
            $(this).parents(".add-trip").remove();
        });
        //增加明细
        $document.on("click",".js-add-detail",function () {
            var $this = $(this);
            var $detailBoxP = $this.parents(".js-detail");
            var $detailBox = $this.parents(".strategy-detail");
            $this.hide();
            $detailBoxP.find(".js-delete-detail").show();
            var $detailTem = $editTemplate.find(".js-detail").clone();
            $detailBox.append($detailTem);
            sort();
        });
        $document.on("click",".js-delete-detail",function () {
            $(this).parents(".js-detail").remove();
            sort();
        });
        //天数排序
        function daySort() {
            var $day = $(".edit-day");
            var $dayLi = $day.find("li");
            for(var i=0;i<$dayLi.length;i++){
                $dayLi.find("span").eq(i).html("D" + (i+1));
            }
        }
        //获取天数
        function getRouteNum() {
            var $day = $(".edit-day");
            var $dayLi = $day.find("li");
            var routeNum = $dayLi.length;
            return routeNum;
        }
        //增加天数
        $document.on("click",".add-edit-day",function () {
            if(getRouteNum()>=15){
                nova.dialog({
                    content: "最多增加15天行程",
                    wrapClass: "delete-all-dialog",
                    time: 2000
                });
                return false;
            }
            var $this = $(this);
            var $thisUl = $this.parent().find(".edit-day");
            $thisUl.append("<li>" +
                    "<span>" +
                    "D" +
                    "</span>" +
                    "<i class='edit-delete-btn nova-icon-xs nova-icon-error'></i>" +
                    "</li>");
            daySort();
            var $detBoxP = $this.parents(".edit-strategy-box").find(".js-detail-box");
            var $detTem = $templateDetail.find(".js-day-detail").clone();
            $detBoxP.append($detTem);
            var routeNum = getRouteNum();
            $detTem.attr("data-day",routeNum);
            $("div[data-day]").hide();
            $("div[data-day='"+routeNum+"']").show();
            $(".edit-day").find("li").removeClass("active");
            $(".edit-day").find("li").eq(routeNum-1).addClass("active");
            var recommendId = $("#recommendId").val();
            var parameter = "recommendId="+ recommendId + "&routeNum="+ routeNum;
            $.ajax({
                url : "/vst_admin/superfreetour/travelRecommendRoute/addRouteNum.do",
                type : "post",
                dataType : 'json',
                data : parameter,
                success : function(result) {
                    if(result.code == "success"){
//                        alert("新增行程天数成功");
                    }else {
                        alert("新增行程天数失败");
                    }
                },
                error : function(){
                    alert("新增行程天数失败");
                }
            });
        });

        //删除某天行程
        $document.on("click",".edit-strategy-day .edit-delete-btn",function () {
            var $this = $(this);
            var $thisIndex = $this.parent().index();
            nova.dialog({
                content:"您确定删除该天行程么？",
                 okClassName:"btn-blue",
                okCallback: function () {
                    //删除该天的行程数据
                    var detailId = $this.attr("detailId");
                    deleteRouteDetail(detailId,($thisIndex+1));
                },
                okText: "确定",
                cancelCallback: true,
                cancelText: "取消",
                wrapClass:"delete-day-dialog"
            });
        });
        //删除某天的行程数据
        function deleteRouteDetail(routeDetailId,dataDay){
            $.ajax({
                url : "/vst_admin/superfreetour/travelRecommendRoute/deleteRouteDetail.do",
                type : "post",
                dataType : 'json',
                data :{
                    routeDetailId:routeDetailId,
                    dayNum:dataDay,
                    recommendId:$("#recommendId").val()
                },
                success : function(result) {
                    if(result.code == "success"){
                        $(".edit-day").find("li").eq(dataDay-1).remove();
                        daySort();
                        $("div[data-day='"+dataDay+"']").remove();
                        $("div[data-day]").each(function(){
                            var tempDay = $(this).attr("data-day");
                            if(tempDay>dataDay){
                                $(this).attr("data-day",tempDay-1);
                            }
                        })
                        if($(".edit-day").find("li.active").length==0){
                            //当前的天被删了
                            if($(".edit-day").find("li").length<dataDay){
                                //最后一天被删了
                                if(dataDay-2>0){
                                    $(".edit-day").find("li").eq(dataDay-2).find("span").trigger("click");
                                }
                            }else{
                                //非最后一天被删了
                                $(".edit-day").find("li").eq(dataDay-1).find("span").trigger("click");
                            }
                        }
                    } else {
                        nova.dialog({
					    content:result.message,
					    okCallback:true,
					    okClassName:"btn-blue",
					    okText: "确定",
					    wrapClass:"delete-all-dialog"
					    });
                    }
                },
                error : function() {
                    alert('删除行程失败');
                }
            });
        }
        
        $document.on("click",".edit-day li span",function () {
            var $this = $(this);
            var $thisIndex = $this.parent().index();
            $this.parent().addClass("active").siblings().removeClass("active");
            $("div[data-day]").hide();
            $("div[data-day='"+($thisIndex+1)+"']").show();
//            $(".js-day-detail").eq($thisIndex).show().siblings(".js-day-detail").hide();

            //获取该天的行程数据
            var detailId = $this.attr("detailId");
            if(detailId != null && detailId != "") {
                if($("div[data-day='"+($thisIndex + 1)+"']").length==0) { //仅仅加载没有加载过的
                    var $detBoxP = $this.parents(".edit-strategy-box").find(".js-detail-box");
                    var $detTem = $templateDetail.find(".js-day-detail").clone();
                    $detBoxP.append($detTem);
                    $detTem.attr("data-day",($thisIndex + 1));
                    $detTem.attr("data-detailid",detailId);
                    $detTem.show();
                    getRouteDetail(detailId, ($thisIndex + 1));
                }
            }else{
                //根本不存在那天，创建页面
                if($("div[data-day='"+($thisIndex + 1)+"']").length==0) { //仅仅加载没有加载过的
                    var $detBoxP = $this.parents(".edit-strategy-box").find(".js-detail-box");
                    var $detTem = $templateDetail.find(".js-day-detail").clone();
                    $detBoxP.append($detTem);
                    $detTem.attr("data-day",($thisIndex + 1));
                    $detTem.show();
                }
            }
                    

        });        
        // 获取某天的行程明细
		function getRouteDetail(routeDetailId,dataday){
			$.ajax({
				url : "/vst_admin/superfreetour/travelRecommendRoute/getNdayRoute.do",
				type : "get",
				dataType :'json',
				data :{routeDetailId:routeDetailId},
				success : function(result) {
                    if(result.code == "success"){
                        var $parentEl = $("div[data-day='"+dataday+"']");
                        var detailGroupList = result.attributes.detailGroupList;
                        $parentEl.find("input[name='routeTitle']").val(result.attributes.routeDetail.routeTitle);
                        var detailSize = detailGroupList.length;
                        for(var i=1;i<detailSize;i++){
                            $parentEl.find(".js-add-detail").eq(i-1).trigger("click");
                        }
                        //填充数据
                        for(var i=0;i<detailSize;i++){
                            initSelectBoxData(dataday,'itemType',detailGroupList[i].propType,i);
                            initSelectBoxData(dataday,'itemTypeDetail',detailGroupList[i].propName,i);
                            $parentEl.find("textarea.edit-tips").eq(i).val(detailGroupList[i].propValue);
                            var photoUrlList=detailGroupList[i].photoUrlList;
                            if(photoUrlList!=null && photoUrlList.length>0){
                                for(var j=0;j<photoUrlList.length;j++){
                                    createImg(dataday,photoUrlList[j],i);
                                }
                            }
                            var ticketList=detailGroupList[i].ticketList;
                            if(ticketList!=null && ticketList.length>0){
                                for(var j=0;j<ticketList.length;j++){
                                    initTicket(dataday,ticketList[j].ticketId,ticketList[j].ticketGoodsId,ticketList[j].ticketName,ticketList[j].ticketGoodsName,i);
                                }
                            }
                        }
                        refreshSensitiveWord($("input[type='text'],textarea"));
                    }else{
                     	nova.dialog({
    						content:result.message,
    						okCallback: true, 
    					    okText: "确定",
    					    okClassName:"btn-blue",
    					    time:2000 //定时关闭 
    					});
                    }
				},
				error : function() {
					alert(' 获取行程明细失败');
				}
			});		
		 }

        $document.on("change",".js-edit-select",function () {
            var $this = $(this);
            var $thisParent = $this.parents(".add-trip");
            var $thisText = $thisParent.find(".edit-tips");
            if($this.val() !=0 ){
                $thisText.addClass("js-edit-yz");
            }
            else{
                $thisText.removeClass("js-edit-yz");
            }
        });
        //第二步保存验证
        $document.on("click",".strategy-save-btn",function () {
            //验证和组装
            var jsonData = {};
            var $thisParent = $(this).parents("div[data-day]");
            //标题
            var $thisTitle = $thisParent.find("input[name='routeTitle']");
            if ($thisTitle.val() == "") {
                nova.dialog({
                    content: "标题不能为空",
                    wrapClass: "delete-all-dialog",
                    time: 2000
                });
                return false;
            }
            jsonData.routeTitle = $thisTitle.val();
            var details = $thisParent.find("div.js-detail");
            jsonData.detailGroupList = [];

            for (var i = 0; i < details.length; i++) {
                var oneDetail = details.eq(i);
                var oneDetailData = {};
                oneDetailData.propType = oneDetail.find("select[data-tag='itemType']").val();
                oneDetailData.propName = $.trim(oneDetail.find("[data-tag='itemTypeDetail']").val().replace(/\s/g, ""));
                if (oneDetailData.propName == null || oneDetailData.propName == "") {
                    nova.dialog({
                        content: "明细不能为空",
                        wrapClass: "delete-all-dialog",
                        time: 2000
                    });
                    return false;
                }
                //组装门票
                var ticketData = [];
                oneDetail.find("li").each(function (j) {
                    if($(this).attr("data-ticketid") && $(this).attr("data-ticketgoodid")){
                        var travelRecommendTicket={
                            ticketId: $(this).attr("data-ticketid"),
                            ticketGoodsId:$(this).attr("data-ticketgoodid")
                        }
                        ticketData.push(travelRecommendTicket);
                    }
                })
                oneDetailData.ticketList = ticketData;
                oneDetailData.propValue = oneDetail.find(".edit-tips").val();
                if (oneDetailData.propValue == null || oneDetailData.propValue == "") {
                    nova.dialog({
                        content: "正文不能为空",
                        wrapClass: "delete-all-dialog",
                        time: 2000
                    });
                    return false;
                }
                //组装图片
                var pics = oneDetail.find(".edit-add-pic");
                var picsData = [];
                for (var j = 0; j < pics.length; j++) {
                    var url = pics.eq(j).attr("data-pic");
                    picsData.push(url);
                }
                oneDetailData.photoUrlList = picsData;
                jsonData.detailGroupList.push(oneDetailData);
            }
            if($thisParent.attr("data-detailId")!=null &&$thisParent.attr("data-detailId")!=""){
                jsonData.detailId=parseInt($thisParent.attr("data-detailId"),10);
            }
            jsonData.nDay=$thisParent.attr("data-day");
            var recommendId = $("#recommendId").val();

            if(refreshSensitiveWord($("input[type='text'],textarea"))) {
            	nova.dialog({
					content:"内容含有敏感词,是否继续?",
					okCallback: function () {
						dosubmit(recommendId,jsonData,$thisParent);
					},
					okClassName:"btn-blue",
					okText: "确定",
					cancelCallback: true,
					cancelText: "取消",
					wrapClass:"delete-all-dialog"
				})
            }else{
                dosubmit(recommendId,jsonData,$thisParent);
            }
        });
        $document.on("click",".JS-upload-item-delete",function () {
            var $this = $(this);
            $this.parent().remove();
        });
        $(".upload-add-image-ul li").on("click",function () {
            var $this = $(this);
            if(!$this.hasClass("last-add-image")){
                $this.addClass("active").siblings().removeClass("active");
            }

        });

    });

    function dosubmit(recommendId,jsonData,$thisParent){
        var loading = nova.loading('<div class="nova-dialog-body-loading"><i></i><br>正在提交中...</div>');
        $.ajax({
            url: "/vst_admin/superfreetour/travelRecommendRoute/saveRoute.do",
            type: "post",
            dataType: 'json',
            data: {
                recommendId:recommendId,
                jsonStr:JSON.stringify(jsonData)
            },
            success: function (result) {
                if (result.code == "success") {
                    //设置行程明细id
                    $thisParent.attr("data-detailId", result.attributes.routeDetailId);
                    var dataday=$thisParent.attr("data-day")
                    $(".edit-day").find("li").eq((dataday-1)).find("span").attr("detailid",result.attributes.routeDetailId);
                    $(".edit-day").find("li").eq((dataday-1)).find("i").attr("detailid",result.attributes.routeDetailId);
                    nova.dialog({
    						content:"保存成功！",
    						okCallback: true,
    					    okText: "确定",
    					    okClassName:"btn-blue",
    					    time:2000 //定时关闭 
    					});
                } else {
                	nova.dialog({
    						content:result.message,
    						okCallback: true,
    					    okText: "确定",
    					    okClassName:"btn-blue",
    					    time:2000 //定时关闭 
    					});
                }
                loading.close();
            },
            error: function () {
            	loading.close();
            	nova.dialog({
    						content:"保存失败！",
    						okCallback: true,
    					    okText: "确定",
    					    okClassName:"btn-blue",
    					    time:2000 //定时关闭 
    					});
            }
        });
    }

    /**
     * 上传图片回调函数
     * @param picob
     */
    function photoCallback(picob){
        window.console && console.log(picob);
        uploadImgDialog.close();
        if(picob!=null && picob.success==true){
            var photos=picob.photos;
            for(var i=0;i<photos.length;i++){
                addImg(photos[i].photoOriginUrl);
            }
        }else{
            //错误提示
            nova.dialog({
                content:"上传错误",
                wrapClass:"delete-all-dialog",
                time: 2000
            });
            window.console && console.log(picob);
        }
    }

    function addImg(picurl){
        var lilength = $uploadImgSrc.parent().find("li").length;
        if(lilength>=7){
        	nova.dialog({
				content:"最多上传6张图片！",
				okCallback: true,
			    okText: "确定",
			    okClassName:"btn-blue",
			    time:2000 //定时关闭 
			});
            return false;
        }
        var $tem = $(".edit-template").find(".edit-add-pic").clone();
        $uploadImgSrc.parent().append($tem);
        $tem.find("img").attr("src","http://pic.lvmama.com/"+picurl);
        $tem.attr("data-pic",picurl);
        return true;
    }
</script>
</body>
</html>
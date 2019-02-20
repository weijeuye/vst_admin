<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/taglibs.ftl"/>

<style type="text/css">
     ul, li, div, span, img, p{margin: 0; padding: 0;}
     #mydiv{width: 670px; background-color: #fff; border: 1px solid #aaa; position: absolute; left: 0px; height: 825px; overflow-y:scroll;}
     #mydiv ul{position: relative; overflow: hidden; list-style: none; margin: 20px 0 15px 10px;}
     #mydiv li{float: left; background-color: #f6f6f6; width: 190px; height: 192px; position: relative; border: 1px solid #ddd; margin-left: 10px; margin-bottom: 10px; cursor: default;}
     #mydiv li.delActive{background-color: #f0f8fd; border: 1px solid #cae8f9;}
     .img-head{padding: 0 5px; overflow: hidden; height: 20px; line-height: 24px; font-family: arail;}
     .img-head span{float: left; font-weight: bold; font-size: 18px;}
     .img-head i{float: right; font-style: normal; font-size: 18px; font-weight: bold; color: #6e6f6f; display: none; cursor: pointer;}
     .img-head i:hover{color: red;}
     .drag-ele img, .moveEle img{width: 180px; height: 120px; padding: 5px;}
     .moveEle{position: absolute; z-index: 2; background-color: #f0f8fd; border: 1px solid #cae8f9; width: 190px; height: 192px; left: 0; right: 0; text-align: center;}
     #mydiv li.emptyEle{border: 1px dashed #dedede; line-height: 190px; text-align: center; color: #ccc; font-size: 16; font-weight: bold;}
     #mydiv li.addImg{line-height: 150px; text-align: center; background: url("${requestURL}${contextPath?trim }/img/addImg.png") no-repeat center center; text-indent: -9999px; background-color: #fff; cursor: pointer;}
     .img-info{padding: 0 5px; font-size: 12px; line-height: 16px; text-align: left;}
 </style>
 
 <style type="text/css">
     #mydiv_52{width: 670px; background-color: #fff; border: 1px solid #aaa; position: absolute; left: 0px; height: 825px; overflow-y:scroll;}
     #mydiv_52 ul{position: relative; overflow: hidden; list-style: none; margin: 20px 0 15px 10px;}
     #mydiv_52 li{float: left; background-color: #f6f6f6; width: 190px; height: 192px; position: relative; border: 1px solid #ddd; margin-left: 10px; margin-bottom: 10px; cursor: default;}
     #mydiv_52 li.delActive_52{background-color: #f0f8fd; border: 1px solid #cae8f9;}
     .img-head_52{padding: 0 5px; overflow: hidden; height: 20px; line-height: 24px; font-family: arail;}
     .img-head_52 span{float: left; font-weight: bold; font-size: 18px;}
     .img-head_52 i{float: right; font-style: normal; font-size: 18px; font-weight: bold; color: #6e6f6f; display: none; cursor: pointer;}
     .img-head_52 i:hover{color: red;}
     .drag-ele_52 img, .moveEle_52 img{width: 180px; height: 120px; padding: 5px;}
     .moveEle_52{position: absolute; z-index: 2; background-color: #f0f8fd; border: 1px solid #cae8f9; width: 190px; height: 192px; left: 0; right: 0; text-align: center;}
     #mydiv_52 li.emptyEle_52{border: 1px dashed #dedede; line-height: 190px; text-align: center; color: #ccc; font-size: 16; font-weight: bold;}
     #mydiv_52 li.addImg_52{line-height: 150px; text-align: center; background: url("${requestURL}${contextPath?trim }/img/addImg.png") no-repeat center center; text-indent: -9999px; background-color: #fff; cursor: pointer;}
     .img-info_52{padding: 0 5px; font-size: 12px; line-height: 16px; text-align: left;}
 </style>

</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">图片维护</a> &gt;</li>
        </ul>
</div>
<div class="tiptext tip-warning">
	<ul class="iframe_nav">
	    <li>说明：<br></li>
	    <li>1.拖动图片位置可以设置图片显示顺序，保存后生效；<br></li>
	    <li>2.第一张图为主图，拖动图片到第一张图即可设置主图，保存后生效<br></li>
	    <#if minNum?? && maxNum == null>
	    	<li>3.最少上传<span style="color:#F00;font-weight:bold">&nbsp;${minNum }&nbsp;</span>张图片<br></li>
	    <#elseif maxNum?? && minNum == null>
	    	<li>3.最多上传<span style="color:#F00;font-weight:bold">&nbsp;${maxNum }&nbsp;</span>张图片 <br></li>
	    <#elseif minNum?? && maxNum??>
	    	<#if minNum == maxNum && minNum &gt; 0>
	    		<li>3.有且仅能上传<span style="color:#F00;font-weight:bold">&nbsp;${minNum }&nbsp;</span>张图片 <br></li>
	    	<#else>
	    		<li>3.可上传<span style="color:#F00;font-weight:bold">&nbsp;${minNum}-${maxNum}&nbsp;</span>张图<br></li>
	    	</#if>
	    </#if>
	</ul>
</div>
<div class="operate" style="margin-bottom:10px;">
	<a class="btn btn_cc1" id="udpate_button" href="javascript:void(0);">保存</a>
	<span style="color:#F00;font-weight:bold">设置图片顺序后请点击“保存”按钮！</span>&nbsp;&nbsp;<span style="font-weight:bold">常规图片添加（3:2）</span>
	<a class="btn btn_cc1" id="batch_delete_button" href="javascript:void(0);">批量删除</a>
	
	<#if categoryId?? && subCategoryId == 181 >
	<#elseif categoryId?? && categoryId == 17>
	<#else>
	     <a href="javascript:void(0);" id="batch_quote_button" class="btn btn_cc1" >引用</a>
	</#if> 
	
	<#if synchronizePhoto>
		<a class="btn btn_cc1" id="batch_synchronize_button" href="javascript:void(0);">图片同步</a>
	</#if>

</div>
<div>
	<!-- 照片限制 -->
	<input type="hidden" id="minNum" name="minNum" value="${minNum }"/>
	<input type="hidden" id="maxNum" name="maxNum" value="${maxNum }"/>
	<form action="#" method="post" id="dataForm">
		<input type="hidden" value="${objectType!''}" name="objectType"  id="objectType"/>
		<input type="hidden" value="${objectId!''}" name="objectId"  id="objectId"/>
		<input type="hidden" value="${parentId!''}" name="parentId"  id="parentId"/>
		<input type="hidden" value="${logType!''}" name="logType"  id="logType"/>
        <input type="hidden" value="${userName}"   id="userName"/>
		
		<div id="mydiv" style="width:1645px;height:800px;text-align: center;">
		    <ul>
		    	<#assign r_index = 0/>
		    	<#list list32 as item> 
			        <li class="drag-ele">
			            <p class="img-head">			                
				            <span class="photoList">
				            <input type="checkBox" id="pic_${item.photoId}" name="checkPhotos" style="display: inline;" value="${item.photoId}">
				            		${item.photoId!'' }
				            </span><i title="删除">×</i></p>
			            <#if item.photoUrl?starts_with('http://m.tuniucdn.com')||item.photoUrl?starts_with('https://m.tuniucdn.com')>
                       		<img src="${item.photoUrl}" width="180" height="120" title="图片" class='picImg32' />
   						<#else>
                        	<img src="http://pic.lvmama.com${item.photoUrl}" width="180" height="120" title="图片" class='picImg32' />
     					</#if>
			            <p class="img-info">${item.photoContent!'' }</p>
			            <input type='hidden' class="delPhotoId" name='photoList[${r_index}].photoId' jsonName="photoId${r_index}" value='${item.photoId }'/>
		    			<input type="hidden" name='photoList[${r_index}].photoSeq' jsonName="photoSeq${r_index}" value="${item.photoSeq!''}"/>	
			        	<input type="hidden" id="fileId" value="${item.fileId}">
					</li>
			        <#assign r_index = r_index + 1/>
			    </#list>
		        <li class="addImg">
		            	添加图片
		        </li>
		    </ul>
		</div>
	</form>
</div>
<div id="photoTypeDiv" style="display:none;">
<table class="p_table form-inline">
            <tr>
            	<td class="p_label" style="width:15%;">选择图片的类型：</td>
                <td>
					<select id="photoType" name="photoType">
						<option value=""></option>
						<#list typeList as type>
							<option value="${type.type!''}">${type.cnName!''}</option>
						</#list>
					</select>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
</table>
</div>

<!-- 5:2图片添加开始 -->
<#if hotelType==1||hotelType==3>
<div class="operate" style="margin-top:855px;margin-bottom:10px;">
	<a class="btn btn_cc1" id="udpate_button_52" href="javascript:void(0);">保存</a>
	<span style="color:#F00;font-weight:bold">设置图片顺序后请点击“保存”按钮！</span>&nbsp;&nbsp;<span style="font-weight:bold">度假酒店详情页专用图片（5:2）</span>
	<a class="btn btn_cc1" id="batch_delete_button_52" href="javascript:void(0);">批量删除</a>
</div>
<div>
	
	<form action="#" method="post" id="dataForm_52">
		
		
		<div id="mydiv_52" style="width:645px;height:800px;text-align: center;">	
		    <ul>
		    	<#assign r_index = 0/>
		    	<#list list52 as item> 
			        <li class="drag-ele_52">
			            <p class="img-head_52">
				            <span class="photoList_52">
				            <input type="checkBox" id="pic_${item.photoId}" name="checkPhotos52" style="display: inline;" value="${item.photoId}">
				            		${item.photoId!'' }
				            </span><i title="删除">×</i></p>
			            <img src="http://pic.lvmama.com${item.photoUrl}" width="180" height="120" title="图片" class='picImg52' />
			            <p class="img-info_52">${item.photoContent!'' }</p>
			            <input type='hidden' class="delPhotoId_52" name='photoList[${r_index}].photoId' jsonName="photoId${r_index}" value='${item.photoId }'/>
		    			<input type="hidden" name='photoList[${r_index}].photoSeq' jsonName="photoSeq${r_index}" value="${item.photoSeq!''}"/>
                        <input type="hidden" id="fileId" value="${item.fileId}">
					</li>
			        <#assign r_index = r_index + 1/>
			    </#list>
		        <li class="addImg_52">
		            	添加图片
		        </li>
		    </ul>
		</div>
	</form>
</div>
</#if>
<!-- 5:2图片添加结束 -->

<#include "/base/foot.ftl"/>
</body>
</html>
<script type="text/javascript">

    var batchQuoteButtonDialog;
    //引用
    $("#batch_quote_button").bind("click",function(){
        var url = "/vst_admin/pub/comphoto/showQuoteProductForm.do?objectId="+${objectId};
        
        batchQuoteButtonDialog = new xDialog(url,{},{title:"系统提示",iframe:true,width:570,height:950});
    });

    function closeDialog(){
        batchQuoteButtonDialog.close();
    }

 function strToObj(str){    
        str = str.replace(/&/g,"','");    
        str = str.replace(/=/g,"':'");    
        str = "({'"+str +"'})";    
        obj = eval(str);     
        return obj;    
 }

 isView();

 function photoExtHtmlCallback() {
 	return $("#photoTypeDiv").html();
 }
 
 
 //全局变量，图片比例，1代表3：2，2代表5：2
    var	photoRatio = 1;
 
 function photoCallback(photoJson, extJson){
	if(photoJson != null && photoJson !=''){
		var objectId = "${objectId!''}";
		var objectType = "${objectType!''}";
		var parentId = "${parentId!''}";
		var logType = "${logType!''}";
		var photoList = new Array();
		if(photoJson.photos) {
			for(var ps in photoJson.photos) {
				var photo = new Object();
				photo.fileId = photoJson.photos[ps].photoId;
				photo.photoContent = photoJson.photos[ps].photoName;
				photo.photoUrl = photoJson.photos[ps].photoUpdateUrl;
				photo.ratio = photoRatio;
				var quondamPhotoContent=photoJson.photos[ps].photoMeasure;
				if(quondamPhotoContent.indexOf("*")>0){
				var arr=quondamPhotoContent.split("*");
				var sourceImgHeight=arr[1];
				var sourceImgWidth=arr[0];
				var jsonstr='{"sourceImgHeight":"'+sourceImgHeight+'","sourceImgWidth":"'+sourceImgWidth+'"}';
				photo.quondamPhotoContent=eval("("+jsonstr+")");
				}
				
				if(extJson){
					extJson = strToObj(extJson);
					photo.photoType = extJson.photoType;
				}
				photoList.push(photo);
			}
		} else if(photoJson.photo) {
			var photo = new Object();
			photo.fileId = photoJson.photo.photoId;
			photo.photoContent = photoJson.photo.photoName;
			photo.photoUrl = photoJson.photo.photoUpdateUrl;
			photo.ratio = photoRatio;
			var quondamPhotoContent=photoJson.photos[ps].photoMeasure;
				if(quondamPhotoContent.indexOf("*")>0){
				var arr=quondamPhotoContent.split("*");
				var sourceImgHeight=arr[1];
				var sourceImgWidth=arr[0];
				var jsonstr='{"sourceImgHeight":"'+sourceImgHeight+'","sourceImgWidth":"'+sourceImgWidth+'"}';
				photo.quondamPhotoContent=eval("("+jsonstr+")");
			}
			if(extJson){
				extJson = strToObj(extJson);
				photo.photoType = extJson.photoType;
			}		
			photoList.push(photo);
		}
		var json = JSON.stringify(photoList);
		
		var jsonData = "photoJson=" + json	+ "&objectId=" + objectId + "&objectType=" + objectType+ "&parentId=" + parentId + "&logType=" + logType;
		$.ajax({
			url : "/vst_admin/pub/comphoto/addBatchComPhoto.do",
			type : "post",
			dataType:"json",
			async: false,
			data : jsonData,
			success : function(result) {
			   if(result.code=="success"){
					alert(result.message);
	   				window.location.reload();
				}else {
					alert(result.message);
		   		}
			}
		});
	}else{
		alert("保存图片失败");
	}
}

$("#batch_delete_button").live('click',function(){ 
    var str="";
    var fieldIds=new Array()
    $("[name='checkPhotos']:checked").each(function(){
       str+=$(this).val()+",";
        fieldIds.push($(this).parents().find("#fileId").val());
     });
     var parentId = $("#parentId").val();
     var logType = "${logType!''}";
	if(str != null && str != ''){
        for(var i=0;i<fieldIds.length;i++){
            $.ajax({
                url : "/photo-back/photo/relation/delete.do?photoId="+fieldIds[i]+"&relationId="+parentId,
                type : "get",
                dataType:"json",
                async: false,
                success : function() {
                }
            });
        }



		$.ajax({
    		url : "/vst_admin/pub/comphoto/batchDeleteComPhoto.do",
    		type : "post",
    		dataType:"json",
    		async: false,
    		data:
    		{
					photoIds:str,
					parentId:parentId,
					logType:logType
			},
    		success : function(result) {
    		   if(result.code=="success"){
    				alert(result.message);
       				window.location.reload();
    			}else {
    				alert(result.message);
    	   		}
    		}
    	});


	}else
	{
	 return;
	}
     
});

$("#batch_delete_button_52").live('click',function(){ 
    var str="";
    var fieldIds=new Array();
    $("[name='checkPhotos52']:checked").each(function(){
       str+=$(this).val()+",";
        fieldIds.push($(this).parents().find("#fileId").val());
     });
     var parentId = $("#parentId").val();
     var logType = "${logType!''}";
	if(str != null && str != ''){
        if(str != null && str != '') {
            for (var i = 0; i < fieldIds.length; i++) {
                $.ajax({
                    url: "/photo-back/photo/relation/delete.do?photoId="+fieldIds[i]+"&relationId="+parentId,
                    type: "get",
                    dataType: "json",
                    async: false,
                    success: function () {
                    }
                });
            }
        }

		$.ajax({
    		url : "/vst_admin/pub/comphoto/batchDeleteComPhoto.do",
    		type : "post",
    		dataType:"json",
    		async: false,
    		data:
    		{
					photoIds:str,
					parentId:parentId,
					logType:logType
			},
    		success : function(result) {
    		   if(result.code=="success"){
    				alert(result.message);
       				window.location.reload();
    			}else {
    				alert(result.message);
    	   		}
    		}
    	});
	}else
	{
	 return;
	}
     
});
  
$(function () {
	var photoListSize = $("span[class=photoList]").size();
	if(photoListSize != null && photoListSize > 0){
		var imgHeadHtml = $('.drag-ele').eq(0).find('.img-head span').html();
        $('.drag-ele').eq(0).find('.img-head span').html(imgHeadHtml + '<lable class="mainFlag" style="color:#F00;font-weight:bold">(主)</lable>');
        
        var minNum = $("#minNum").val();
	    var maxNum = $("#maxNum").val();
		if(minNum != null && minNum.length > 0 && maxNum != null && maxNum.length > 0){
			if(maxNum == minNum || photoListSize >= parseInt(maxNum)){
				$(".addImg").hide();
			}
		}else if(maxNum != null && maxNum.length > 0){
			if(photoListSize >= parseInt(maxNum)){
				$(".addImg").hide();
			}
		}
	}
	
    //回调函数
    function dragCallBack(){
    }

    //图片说明30个字，超出则截断；
    var len = $('.img-info').length;
    for(var i=0; i<len; i++){
        var txt = $('.img-info').eq(i).text();
        if(txt.length>30){
            var newTxt = txt.substr(0,28) + '…';
            $('.img-info').eq(i).text(newTxt);
        }
    }

     //禁止文本选中，处理chrome的bug
     document.body.onselectstart=function(){
        return false;
     };

    /*hover效果和删除*/
    $('.drag-ele').hover(function(){
        $(this).addClass('delActive');
        $(this).find('i').show();
        $(this).find('i').on('click', function(){
        	var delPhotoId = $($(this).parents('li').find("input[name^='photoList']")[0]).val();
            var fileId = $($(this).parents('li').find("#fileId")).val();
        	delPhoto(delPhotoId,fileId);
        	
            $(this).parents('li').remove();
            sortNum();
            return false;
        })
    },function(){
        $(this).removeClass('delActive');
        $(this).find('i').hide();
    });

    /*编号重排*/
    function sortNum(){
        var eleLen = $('.drag-ele').length;
        for(var i=0; i<eleLen; i++){
            var index = i+1;
            var imgHead = $('.drag-ele').eq(i).find('.img-head span');
            $(imgHead).find(".mainFlag").empty();
			if(i == 0){
				 $('.drag-ele').eq(i).find('.img-head span').html(imgHead.html() + '<lable class="mainFlag" style="color:#F00;font-weight:bold">(主)</lable>');
			}else{
				$('.drag-ele').eq(i).find('.img-head span').html(imgHead.html());
			}
        }
        
        var photoListSize = $("span[class=photoList]").size();
        if(photoListSize == 0 && parseInt($("#minNum").val()) > 0){
        	$(".addImg").show();
        }
    }

    //元素移动
    var _bool = false, //鼠标是否按下
            cloneEle,
            moveEle,
            evtX,
            evtY;
            
	$('.picImg32').on('mousedown', function (e) {
	        _bool = true;
	        if(e.target.tagName.toUpperCase() == 'I'){
	            return false;
	        }
	        if(e.which !== 1){
	            return false;
	        }
	        var $this_li = $(this).parent('.drag-ele');
	        if(!cloneEle) cloneEle = $this_li.clone(true);
	        moveEle = "<div class='moveEle'>"+cloneEle.html()+"</div>"; //移动的新元素
	        $('body').append(moveEle);  //在页面增加移动元素；
	        $this_li.html("拖动到这里").addClass('emptyEle').css('background-color','#f6f6f6');  //把目标元素变成空白内容
	
	        evtX = e.pageX+10;
	        evtY = e.pageY+20;
	        $('.moveEle').css('left', evtX + 'px');
	        $('.moveEle').css('top', evtY + 'px');
	    });
    
    $('#mydiv').delegate('.drag-ele','mousemove', function (e) {
        if (!_bool) {
            return false
        }
        $(this).removeClass('delActive');

        evtX = e.pageX+10;
        evtY = e.pageY+20;
        $('.moveEle').css('left', evtX + 'px');
        $('.moveEle').css('top', evtY + 'px');
        if($(e.currentTarget).hasClass('emptyEle')){
            return false;
        }else{
            var curIndex = $('.drag-ele').index($(e.currentTarget));
            var empIndex = $('.drag-ele').index($('.emptyEle'));
            if(curIndex<empIndex){
                $(e.currentTarget).before($('.emptyEle'));
            }else{
                $(e.currentTarget).after($('.emptyEle'));
            }
        }
    });
    
    $(document).bind('mouseup', function () {
        if (_bool) {
        	if(cloneEle)
            	cloneEle.css({'left':'auto', 'top':'auto'});
            $('.emptyEle').replaceWith(cloneEle);
            $('.moveEle').remove();
            cloneEle = "";
            sortNum();
            //调用回调函数
            dragCallBack();
        }
        $('.drag-ele').removeClass('delActive');
        _bool = false;
    })
    

    
    $(".addImg").bind("click",function(){
        var relationType=$("#categoryId", window.parent.document).val();
        var relationAuthor=$("#userName").val();
    	if($("#objectType").val() != "" && $("#objectId").val() != "") {
    		/*var url = "/pic/photo/photo/imgPlugIn.do";*/
            var url = "/photo-back/photo/photo/imgPlugIn.do";
    		url += "?relationId=${objectId!''}&relationType="+relationType+"&relationAuthor="+relationAuthor+"&relationTime="+new Date().Format("yyyyMMdd")+"&photoSource=vst";
    		if("${imgLimitType!'' }" != '') {
    			url += "&imgLimitType=${imgLimitType!''}"
    		}
    		//设置图片尺寸表示为1
    		photoRatio = 1;
    		comPhotoAddDialog = new xDialog(url,{},{title:"上传图片",iframe:true,width:920,height:750});
		}	
    });

    //增加5：2的图片
    $(".addImg_52").bind("click",function(){
        var relationType=$("#categoryId", window.parent.document).val();
        var relationAuthor=$("#userName").val();
    	if($("#objectType").val() != "" && $("#objectId").val() != "") {
    		/*var url = "/pic/photo/photo/imgPlugIn.do";*/
            var url = "/photo-back/photo/photo/imgPlugIn.do";
            url += "?relationId=${objectId!''}&relationType="+relationType+"&relationAuthor="+relationAuthor+"&relationTime="+new Date().Format("yyyyMMdd")+"&photoSource=vst";
    		if("${imgLimitType!'' }" != '') {
    			url += "&imgLimitType=LIMIT_5_2_3L"
    		}
    		//设置图片尺寸表示为1
    		photoRatio = 2;
    		comPhotoAddDialog = new xDialog(url,{},{title:"上传图片",iframe:true,width:920,height:750});
		}	
    });
    
    function delPhoto(photoId,fileId){
        var productId = $("#objectId").val();
		if(photoId != null && photoId != ''){
			var jsonData = "id=" + photoId + "&parentId=" + $("#parentId").val();
			$.ajax({
	    		url : "/vst_admin/pub/comphoto/deleteComPhoto.do",
	    		type : "post",
	    		dataType:"json",
	    		async: false,
	    		data : jsonData,
	    		success : function(result) {
	    		   if(result.code=="success"){
	    				alert(result.message);
	       				window.location.reload();
	    			}else {
	    				alert(result.message);
	    	   		}
	    		}
	    	});

        $.ajax({
                url : "/photo-back/photo/relation/delete.do?photoId="+fileId+"&relationId="+productId,
                type : "get",
                dataType:"json",
                async: false,
				success : function() {

				}
            });
		}else{
			return;
		}
	}

    //Added by yangzhenzhong
    $("#batch_synchronize_button").bind("click",function(){
        var message='确定要同步图片吗？除了在当前产品上添加的图片，其余图片会重新由打包产品同步过来。';
//		$.confirm(message,function () {
//            synchronizePhoto();
//
//		});
		if(confirm(message)){
            synchronizePhoto();
		}

	});


    $("#udpate_button").bind("click",function(){
    	var photoListSize = $("span[class=photoList]").size();
    	if(photoListSize < 1){
    		alert("无图片不能保存");
        	return false;
    	}
    	
    	
    	
    	//图片限制
    	var minNum = $("#minNum").val();
    	var maxNum = $("#maxNum").val();
    	if(minNum != null && minNum.length > 0 && maxNum != null && maxNum.length > 0){
			if(maxNum == minNum && (photoListSize > minNum || photoListSize < minNum)){
				alert("有且仅能上传 " + minNum + " 张照片");
        		return false;
			}
		}
    	
    	if(minNum != null && minNum.length >0 ){
    		if(photoListSize < parseInt(minNum)){
    			alert("至少上传 " + minNum + " 张照片");
        		return false;
    		}
    	}
    	
    	if(maxNum != null  && maxNum.length >0){
    		if(photoListSize > parseInt(maxNum)){
    			alert("最多上传 " + maxNum + " 张照片");
        		return false;
    		}
    	}
    	
    	//封装json数据
    	var photoArr = new Array();
    	var eleLen = 0;
    	if($('.drag-ele') != null && $('.drag-ele').length > 0){
    		eleLen = $('.drag-ele').length;
    	}
    	
        for(var i=0; i<eleLen; i++){
        	var photo = new Object();
            var inputObj = $('.drag-ele').eq(i).find('input');
            photo.photoId = $(inputObj.eq(0)).val();
            photo.ratio = 1;
            photoArr.push(photo);
        }
    	
    	var photoJson = "";
    	if(photoArr != null && photoArr.length > 0){
    		photoJson = JSON.stringify(photoArr)
    	}
    	
    	var jsonData = "photoJson=" + photoJson 
    		+ "&objectId=" + $("#objectId").val()
    		+"&objectType=" + $("#objectType").val()
    		+"&parentId=" + $("#parentId").val()
    		+"&logType=" + $("#logType").val()
    		+"&ratio=1";
    		
    	$.ajax({
    		url : "/vst_admin/pub/comphoto/updateComPhoto.do",
    		type : "post",
    		dataType:"json",
    		async: false,
    		data : jsonData,
    		success : function(result) {
    		   if(result.code=="success"){
    				alert(result.message);
       				window.location.reload();
    			}else {
    				alert(result.message);
    	   		}
    		}
    	});
    });
});

 //Added by yangzhenzhong
function synchronizePhoto(){

//    var synchronizePhotoLoading = $.loading("正在同步中...");
    var jsonData = "objectId=" + $("#objectId").val()
                    +"&objectType=" + $("#objectType").val()
                    +"&parentId=" + $("#parentId").val()
                    +"&logType=" + $("#logType").val()
                    +"&ratio=1";

	$.ajax({
		url : "/vst_admin/pub/comphoto/synchronizePhoto.do",
		type : "post",
		dataType:"json",
		async: false,
		data : jsonData,
		success : function(result) {
//            synchronizePhotoLoading.close();
			if(result.code=="success"){
				alert('同步成功');
				window.location.reload();
			}else {
				alert('同步失败');
			}
		}
	});
}

    Date.prototype.Format = function (fmt) { //author: fangxiang
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "h+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }


</script>

<script type="text/javascript">


 

$(function () {
	var photoListSize_52 = $("span[class=photoList_52]").size();
	if(photoListSize_52 != null && photoListSize_52 > 0){
		var imgHeadHtml_52 = $('.drag-ele_52').eq(0).find('.img-head_52 span').html();
        $('.drag-ele_52').eq(0).find('.img-head_52 span').html(imgHeadHtml_52 + '<lable class="mainFlag_52" style="color:#F00;font-weight:bold">(主)</lable>');
        
        var minNum_52 = $("#minNum").val();
	    var maxNum_52 = $("#maxNum").val();
		if(minNum_52 != null && minNum_52.length > 0 && maxNum_52 != null && maxNum_52.length > 0){
			if(maxNum_52 == minNum_52 || photoListSize_52 >= parseInt(maxNum_52)){
				$(".addImg_52").hide();
			}
		}else if(maxNum_52 != null && maxNum.length_52 > 0){
			if(photoListSize_52 >= parseInt(maxNum_52)){
				$(".addImg_52").hide();
			}
		}
	}
	
    

    //图片说明30个字，超出则截断；
    var len_52 = $('.img-info_52').length;
    for(var i=0; i<len_52; i++){
        var txt_52 = $('.img-info_52').eq(i).text();
        if(txt_52.length>30){
            var newTxt_52 = txt_52.substr(0,28) + '…';
            $('.img-info_52').eq(i).text(newTxt_52);
        }
    }


    
    
    //元素移动
    var _bool = false, //鼠标是否按下
            cloneEle,
            moveEle,
            evtX,
            evtY;

    /*hover效果和删除*/
    $('.drag-ele_52').hover(function(){
        $(this).addClass('delActive_52');
        $(this).find('i').show();
        $(this).find('i').on('click', function(){
        	var delPhotoId = $($(this).parents('li').find("input[name^='photoList']")[0]).val();
        	delPhoto_52(delPhotoId);
        	
            $(this).parents('li').remove();
            sortNum_52();
            return false;
        })
    },function(){
        $(this).removeClass('delActive_52');
        $(this).find('i').hide();
    });

    /*编号重排*/
    function sortNum_52(){
        var eleLen = $('.drag-ele_52').length;
        for(var i=0; i<eleLen; i++){
            var index = i+1;
            var imgHead = $('.drag-ele_52').eq(i).find('.img-head_52 span');
            $(imgHead).find(".mainFlag_52").empty();
			if(i == 0){
				 $('.drag-ele_52').eq(i).find('.img-head_52 span').html(imgHead.html() + '<lable class="mainFlag_52" style="color:#F00;font-weight:bold">(主)</lable>');
			}else{
				$('.drag-ele_52').eq(i).find('.img-head_52 span').html(imgHead.html());
			}
        }
        
        var photoListSize = $("span[class=photoList_52]").size();
        if(photoListSize == 0 && parseInt($("#minNum").val()) > 0){
        	$(".addImg_52").show();
        }
    }

    
    $('.picImg52').on('mousedown', function (e) {
        _bool = true;
        if(e.target.tagName.toUpperCase() == 'I'){
            return false;
        }
        if(e.which !== 1){
            return false;
        }
        var $this_li = $(this).parent('.drag-ele_52');
        if(!cloneEle) cloneEle = $this_li.clone(true);
        moveEle = "<div class='moveEle'>"+cloneEle.html()+"</div>"; //移动的新元素
        $('body').append(moveEle);  //在页面增加移动元素；
        $this_li.html("拖动到这里").addClass('emptyEle').css('background-color','#f6f6f6');  //把目标元素变成空白内容

        evtX = e.pageX+10;
        evtY = e.pageY+20;
        $('.moveEle').css('left', evtX + 'px');
        $('.moveEle').css('top', evtY + 'px');
    });
    
    $('#mydiv_52').delegate('.drag-ele_52','mousemove', function (e) {
        if (!_bool) {
            return false;
        }
        $(this).removeClass('delActive_52');

        evtX = e.pageX+10;
        evtY = e.pageY+20;
        $('.moveEle').css('left', evtX + 'px');
        $('.moveEle').css('top', evtY + 'px');
        if($(e.currentTarget).hasClass('emptyEle')){
            return false;
        }else{
            var curIndex = $('.drag-ele_52').index($(e.currentTarget));
            var empIndex = $('.drag-ele_52').index($('.emptyEle'));
            if(curIndex<empIndex){
                $(e.currentTarget).before($('.emptyEle'));
            }else{
                $(e.currentTarget).after($('.emptyEle'));
            }
        }
    });
    
    $(document).bind('mouseup', function () {
        if (_bool) {
        	if(cloneEle)
            	cloneEle.css({'left':'auto', 'top':'auto'});
            $('.emptyEle').replaceWith(cloneEle);
            $('.moveEle').remove();
            cloneEle = "";
            sortNum_52();
            //调用回调函数
            dragCallBack_52();
        }
        $('.drag-ele_52').removeClass('delActive_52');
        _bool = false;
    })
    
    //回调函数
    function dragCallBack_52(){
    }
    
    
    function delPhoto_52(photoId){
        var productId = $("#objectId").val();
		if(photoId != null && photoId != ''){
			var jsonData = "id=" + photoId + "&parentId=" + $("#parentId").val();
			$.ajax({
	    		url : "/vst_admin/pub/comphoto/deleteComPhoto.do",
	    		type : "post",
	    		dataType:"json",
	    		async: false,
	    		data : jsonData,
	    		success : function(result) {
	    		   if(result.code=="success"){
	    				alert(result.message);
	       				window.location.reload();
	    			}else {
	    				alert(result.message);
	    	   		}
	    		}
	    	});
		}else{
			return;
		}
	}
	
	
	
	$("#udpate_button_52").bind("click",function(){
    	var photoListSize = $("span[class=photoList_52]").size();
    	if(photoListSize < 1){
    		alert("无图片不能保存");
        	return false;
    	}
    	
    	
    	
    	//图片限制
    	var minNum = $("#minNum").val();
    	var maxNum = $("#maxNum").val();
    	if(minNum != null && minNum.length > 0 && maxNum != null && maxNum.length > 0){
			if(maxNum == minNum && (photoListSize > minNum || photoListSize < minNum)){
				alert("有且仅能上传 " + minNum + " 张照片");
        		return false;
			}
		}
    	
    	if(minNum != null && minNum.length >0 ){
    		if(photoListSize < parseInt(minNum)){
    			alert("至少上传 " + minNum + " 张照片");
        		return false;
    		}
    	}
    	
    	if(maxNum != null  && maxNum.length >0){
    		if(photoListSize > parseInt(maxNum)){
    			alert("最多上传 " + maxNum + " 张照片");
        		return false;
    		}
    	}
    	
    	//封装json数据
    	var photoArr = new Array();
    	var eleLen = 0;
    	if($('.drag-ele_52') != null && $('.drag-ele').length > 0){
    		eleLen = $('.drag-ele_52').length;
    	}
    	
        for(var i=0; i<eleLen; i++){
        	var photo = new Object();
            var inputObj = $('.drag-ele_52').eq(i).find('input');
            photo.photoId = $(inputObj.eq(0)).val();
            photo.ratio = 2;
            photoArr.push(photo);
        }
    	
    	var photoJson = "";
    	if(photoArr != null && photoArr.length > 0){
    		photoJson = JSON.stringify(photoArr)
    	}
    	
    	var jsonData = "photoJson=" + photoJson 
    		+ "&objectId=" + $("#objectId").val()
    		+"&objectType=" + $("#objectType").val()
    		+"&parentId=" + $("#parentId").val()
    		+"&logType=" + $("#logType").val()
    		+"&ratio=2";
    		
    	$.ajax({
    		url : "/vst_admin/pub/comphoto/updateComPhoto.do",
    		type : "post",
    		dataType:"json",
    		async: false,
    		data : jsonData,
    		success : function(result) {
    		   if(result.code=="success"){
    				alert(result.message);
       				window.location.reload();
    			}else {
    				alert(result.message);
    	   		}
    		}
    	});
    });

});
</script>

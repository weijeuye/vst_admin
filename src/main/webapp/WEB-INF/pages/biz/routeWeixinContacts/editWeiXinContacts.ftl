<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
<style type="text/css">
     ul, li, div, span, img, p{margin: 0; padding: 0;}
     #mydiv{width: 300px; background-color: #fff; height: 400px;}
     #mydiv ul{position: relative; overflow: hidden; list-style: none; margin: 20px 0 15px 10px;}
     #mydiv li{float: left; background-color: #f6f6f6; width: 215px; height: 235px; position: relative; border: 1px solid #ddd; margin-left: 10px; margin-bottom: 10px; cursor: default;}
     .img-head{padding: 0 5px; height: 20px; line-height: 24px; font-family: arail;}
     .img-head i{float: right; font-style: normal; font-size: 18px; font-weight: bold; color: #6e6f6f;cursor: pointer;}
     .img-head i:hover{color: red;}
     .drag-ele img, .moveEle img{padding: 5px;}
     #mydiv li.emptyEle{border: 1px dashed #dedede; text-align: center; color: #ccc; font-size: 16; font-weight: bold;}
     #mydiv li.addImg{line-height: 150px; background: url("http://super.lvmama.com/vst_admin/img/addImg.png") no-repeat center center; text-indent: -9999px; background-color: #fff; cursor: pointer;}
 </style>
</head>
<body>
<div>
	<form method="post" id="addForm" >
		<table class="e_table ">
			<tr>
				<td class="w15"style="text-align:right; ">类别：</td>
				<td class="w15">
					<#if weiXinContact.weiXinBuType =='INNER' ><span>国内</span>
					<#elseif weiXinContact.weiXinBuType =='FOREIGN'><span>出境</span>
					</#if>
					<input type="hidden" id="weiXinBuType" name="weiXinContact.weiXinBuType" value="${weiXinContact.weiXinBuType}"/>
		        </td>
			</tr>
			<tr>
				<td class="w15"style="text-align:right; ">品类：</td>
	            <td>
	            	<select class="form-control w90" id="categoryId" name="weiXinContact.categoryId" disabled="disabled">
	                    <option value=${weiXinContact.categoryId!''} selected><#if weiXinContact.bizCategory ??>${weiXinContact.bizCategory.categoryName!''}</#if></option>
		            </select>
	            </td>
			</tr>
			<tr id="subcategoryTr" style="display:none">
				<td class="w15"style="text-align:right; ">子品类：</td>
				<td>
					<div class="inline-block">
	            	 <select class="form-control w120" id="subCategoryId" name="weiXinContact.subCategoryId" disabled="disabled">
                    	<option value='${weiXinContact.subCategoryId!''}' selected><#if weiXinContact.subCategory ??>${weiXinContact.subCategory.categoryName!''}</#if></option>
	                </select>
	           	 </div>
				</td>
			</tr>
			<tr>
				<td class="w15"style="text-align:right; ">联系人微信号：</td>
				<td>
					<input class="w90" type="text" id="contactsAccount" maxlength="100" name="weiXinContact.contactsAccount" value=${weiXinContact.contactsAccount} ">
		        </td>
			</tr>
			<tr>
				<td class="w15"style="text-align:right; ">微信二维码：</td>
				<td>
					<div id="mydiv" style="width:260px;height:260px;">	      
					<ul>
						<li class="drag-ele">
							<p class="img-head">			                
					            <span class="photoList">
					            <input type='hidden' id="photoId" name="weiXinContact.photoId" value="${weiXinContact.photoId}">
					            <input type='hidden' id="photoUrl" name="weiXinContact.photoUrl" value="${weiXinContact.photoUrl}">
					            </span>
					            <i title="删除" id="delete">×</i></p>
				            <img src="http://pic.lvmama.com${weiXinContact.photoUrl}"width="200" height="200" title="图片" id="img" />
				        </li>
						<li class="addImg" style="display:none">
			            	添加图片
			        	</li>
			        	<div><span style="color:red">注：请上传比例为1:1的图片</span> </div>
					</ul>
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
               <td><a class="btn btn_cc1" id="save">保存</a> </td>
            </tr>
		</table>
	</form>
</div>
</body>
</html>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js,js/backstage/v1/common/validate.js,js/backstage/v1/common/float-alert.js,js/backstage/v1/common/sortable.js"></script>
<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>
<script>
var $imageOperate = null;
	$("#delete").bind("click",function(){
		var photoId=$("#photoId").val();
    	$.confirm("确定从图库删除吗？删除后务必上传新的二维码并保存！！！",function(){
			var url = "/photo-back/photo/photo/delete.do";
		 	$.ajax({
				url : url,
				type : "post",
				data : {photoId:photoId},
				success : function(result) {
					if(result=="SUCESS"||result=="MAYNOTEXIST"){
						$.alert("删除图片成功");
					}else{
						$.alert("删除图片失败");
					}
					$("#photoId").val("");
					$("#photoUrl").val("");
					$(".drag-ele").hide();
					$(".addImg").show();
				},
				error :function(result) {
					$("#photoId").val("");
					$("#photoUrl").val("");
					$(".drag-ele").hide();
					$(".addImg").show();
				}
			});
    	});
    });

$(function() {
	var  categoryId = '${weiXinContact.categoryId}';
	if(categoryId=="18"){
		$("#subcategoryTr").show();
	}
	
	$("#categoryId").bind("change", function(){
    	var $categoryId = $(this).val();
    	if($categoryId==18){
    		$("#subcategoryTr").show();
    	}else{
    		$("#subcategoryTr").hide();
    		$("#subCategoryId").val("");
    	}
    });
	
	//添加图片按钮
     $(".addImg").bind("click",function(){
            var url = "/photo-back/photo/photo/imgPlugIn.do";
    		url += "?relationType=1";
    		url+="&referType=prodMaintain";
    		$imageOperate =$.dialog({
    		mask:true, width: 900, height: 500, title: "上传图片",
	   		 content: url,
    		});
    });
    
	//保存
	$("#save").bind("click",function(){
		var weiXinBuType='${weiXinContact.weiXinBuType}';
		var contactId='${weiXinContact.contactId}';
	 	var categoryId = $("#categoryId").val();
        var contactsAccount =$("#contactsAccount").val();
        var subCategoryId =$("#subCategoryId").val();
        var photoId = $("#photoId").val();
        var photoUrl = $("#photoUrl").val();
        if(categoryId == 18){
        	if(subCategoryId == '' || weiXinBuType ==''||contactsAccount==''||photoId==''||photoUrl==''){
        		$.alert("请检查信息是否已全部填写！")
        		return false;
        	}
        }else{
        	if(categoryId == ''|| weiXinBuType ==''||contactsAccount==''||photoId==''||photoUrl==''){
        		$.alert("请检查信息是否已全部填写！")
        		return false;
        	}
        }
       $.ajax({
			url : "/vst_admin/biz/weiXinContacts/addOrUpdateContact.do",
			type : "post",
			dataType : 'json',
			data : {
				weiXinBuType:weiXinBuType,
				contactId:contactId,
				categoryId:categoryId,
				subCategoryId:subCategoryId,
				contactsAccount:contactsAccount,
				photoId:photoId,
				photoUrl:photoUrl
			},
			success : function(result) {
				 if(result.code=="success"){
				 	$.alert("保存成功",function(){
						window.parent.location.href="/vst_admin/biz/weiXinContacts/findWeiXinContacts.do?weiXinBuType="+weiXinBuType;
					});
				}else if(result.code=="error"){
					$.alert("保存失败",function(){
						window.parent.location.href="/vst_admin/biz/weiXinContacts/findWeiXinContacts.do?weiXinBuType="+weiXinBuType;
					});
				}
			},
			error : function(result) {
				$.alert(result.message);
			}
		});
        
	});
	
	
 });   
	 //回调函数
    function photoCallback(photoJson, extJson){
    	if(photoJson != null && photoJson !=''){
			if(photoJson.photos) {
				for(var ps in photoJson.photos) {
					$("#photoId").val(photoJson.photos[ps].photoId);
					$("#photoUrl").val(photoJson.photos[ps].photoUpdateUrl);
					$("#img").attr("src","http://pic.lvmama.com"+photoJson.photos[ps].photoUpdateUrl);
				}
				$(".drag-ele").show();
				$(".addImg").hide();
			} else if(photoJson.photo) {
				$("#photoId").val(photoJson.photo.photoId);
				$("#photoUrl").val(photoJson.photo.photoUpdateUrl);
				$("#img").attr("src","http://pic.lvmama.com"+photoJson.photo.photoUpdateUrl);
			}
			$imageOperate.close();	
		}else{
			alert("添加图片失败");
		}
	}
</script>	
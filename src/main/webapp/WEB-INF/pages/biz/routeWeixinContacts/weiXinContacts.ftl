<!DOCTYPE html>
<html>
<head>
</head>
<body>
<a class="btn" id="new_button" style="color:#fff;background:#4d90fe; width:100px;line-height:25px;margin:10px 10px 10px 0">新增</a>
<#if weiXinContactList?? && (weiXinContactList?size>0)>
	    <table class="table table-border">
	        <colgroup>
	            <col class="w150"/>
	            <col class="w150"/>
	            <col class="w350"/>
	            <col class="w100"/>
	            <col class="w200"/>
	            
	        </colgroup>
	        <thead>
	        <tr>
	            <th class="text-center">品类</th>
	            <th class="text-center">子品类</th>
	            <th class="text-center">联系人微信号</th>
	            <th class="text-center">微信二维码</th>
	            <th class="text-center">操作</th>
	        </tr>
	        </thead>
	        <tbody>
	        <#list weiXinContactList as weiXinContact> 
	        	<tr>
				<input type="hidden" name="weiXinContact.weiXinBuType" value="${weiXinBuType}">
		            <td style="text-align:center; "><#if weiXinContact.bizCategory ??>${weiXinContact.bizCategory.categoryName!''}</#if></td>
		            <td style="text-align:center; "><#if weiXinContact.subCategory ??>${weiXinContact.subCategory.categoryName!''}<#else>无</#if></td>
		            <td>${weiXinContact.contactsAccount!''}</td>
		            <td>
			            <div>
			            	<img src="http://pic.lvmama.com${weiXinContact.photoUrl}"  style="margin:0 auto" width="180" height="180" title="图片" />
		            	</div>
		            	<input type='hidden' id="photoId" name="weiXinContact.photoId" value="${weiXinContact.photoId}">
		            </td>
		            <td class="oper">
			            <a href="javascript:void(0);" class="editProd" data="${weiXinContact.contactId}">编辑</a>
			            <a href="javascript:void(0);" class="delete" data="${weiXinContact.contactId}" data1="${weiXinContact.photoId}" >删除</a>
			            <a class="showLogDialog" href="javascript:void(0);"  param='objectId=${weiXinContact.contactId!''}&objectType=WEIXIN_CONTACT_OPERATE&sysName=VST'>操作日志</a>
		            </td>
	             </tr>
             </#list>
	        </tbody>
	    </table>
<#else>
	<div class="hint mb10">
        <span class="icon icon-big icon-info"></span>暂无数据，请新增品类二维码信息
    </div>
</#if>

</body>
</html>

<script>
 $("#new_button").bind("click",function(){
 	var weiXinBuType="${weiXinBuType}";
 	var newcontact=$.dialog({
	    mask:true, width: 1200, title: "新增微信联系人",
	    content: "/vst_admin/biz/weiXinContacts/addWeiXinContacts.do?weiXinBuType="+weiXinBuType
	});
 });
 
 //编辑
	$(".editProd").bind("click",function(){
		var id = $(this).attr("data");
		var editcontact=$.dialog({
		    mask:true, width: 1200, title: "编辑微信联系人",
		    content: "/vst_admin/biz/weiXinContacts/editWeiXinContacts.do?id="+id
		});
	});
 //删除
 $(".delete").bind("click",function(){
		var id = $(this).attr("data");
		var photoId=$(this).attr("data1");
		var weiXinBuType="${weiXinBuType}";
		$.confirm("确认删除?",function(){
			$.ajax({
			url : "/vst_admin/biz/weiXinContacts/delete.do",
			type : "post",
			dataType : 'json',
			data : {id:id},
			success : function(result) {
				 if(result.code=="success"){
				 	var url = "/photo-back/photo/photo/delete.do";
				 	$.ajax({
						url : url,
						type : "post",
						data : {photoId:photoId},
						success : function(msg) {
							if(msg=="SUCESS"||msg=="MAYNOTEXIST"){
								$.alert("删除成功",function(){
									$.post("/vst_admin/biz/weiXinContacts/changeWeiXinContacts.do",{"weiXinBuType":weiXinBuType},function(returnData){
										if(returnData){
											$("#mainContent").html(returnData);
										}
									});
								});
							}else{
								$.alert("图库接口删除图片失败",function(){
									$.post("/vst_admin/biz/weiXinContacts/changeWeiXinContacts.do",{"weiXinBuType":weiXinBuType},function(returnData){
										if(returnData){
											$("#mainContent").html(returnData);
										}
									});
								});
							}
						},
						error :function(msg) {
							$.alert("图库接口删除图片失败",function(){
									$.post("/vst_admin/biz/weiXinContacts/changeWeiXinContacts.do",{"weiXinBuType":weiXinBuType},function(returnData){
										if(returnData){
											$("#mainContent").html(returnData);
										}
									});
								});
						}
					});
				}
			},
			error : function(result) {
				$.alert("删除失败："+result.message);
			}
		});
		});
	});
</script>


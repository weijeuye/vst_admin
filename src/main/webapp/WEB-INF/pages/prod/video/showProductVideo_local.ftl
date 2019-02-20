<!DOCTYPE html>
<html>
<head>
<style>
.videocontent *{
	display:inline-block;
}
tr{
   height:35px;
}

span{
   font-size:14px;
   float:right;
   margin-right:15px;
}

</style>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
	<ul class="iframe_nav">
		<li><a href="#">视频维护</a>&gt;</li>
	</ul>
</div>

<div class="iframe_search">
	<div class="tiptext tip-warning cc5">
		<span class="tip-icon tip-icon-warning"></span>说明：
		<p class="pl15">1.本地视频转为播放代码请至“www.bokecc.com”</p>
		<p class="pl15">2.排序值按1—5由小到大排序</p>
	</div>
	
	<div class="p_box box_info clearfix">
	    <h2 class="f16 mb10">视频管理</h2>	        
	</div>
	
	<div class="p_box box_info clearfix">
	    <a class="btn btn_cc1" style="border-radius:5px;background-color:#fff;" id="getChildVideo" href="javascript:void(0);">获取打包产品视频</a>	
	    <a class="btn btn_cc1" style="width:120px;;border-radius:5px;background-color:#4d90fe;border-color:#4d90fe;color:#fff !important;margin-left:150px;" id="btnAddVideo" href="javascript:void(0);">+添加视频</a>		        
	</div>

<!-- 主内容显示区域 -->
	<div>
		<#list prodVideoList as prodVideo>
			<div class="video" style="width:800px;float:left;padding-top:20px;">
			  <form class="dataform">
				<input type="hidden" class="videoID" name="videoID" value="${prodVideo.videoID}" />
				<input type="hidden" class="objectId" name="objectId" value="${prodVideo.objectId}" />
				<input type="hidden" class="bizCategoryId" name="bizCategoryId" value="${prodVideo.bizCategoryId}" />
				<input type="hidden" class="status" name="status" value="${prodVideo.status}" />
				<input type="hidden" class="childObjectId" name="childObjectId" value="${prodVideo.childObjectId}" />
				<input type="hidden" class="childBizCategoryId" name="childBizCategoryId" value="${prodVideo.childBizCategoryId}" />
				<input type="hidden" class="childVideoId" name="childVideoId" value="${prodVideo.childVideoId}" />
				<input type="hidden" class="childStatus" name="childStatus" value="${prodVideo.childStatus}" />
				<table width="600px">
					<tr>
						<td>
						    <b style="font-size:16px;color:#06c;">视频${prodVideo_index + 1}</b>
						</td>
						<td>
						    <button class="btn" style="border-radius:5px;margin-left:50px;margin-bottom:6px;width:70px;height:26px;background-color:#fff;" data-id="${prodVideo.videoID}" onclick="updateProductVideo(this)">删除</button>
						</td>
					</tr>
					<tr>
					    <td><span>ID:</span></td>
					    <td><input type="text" style="width:350px;" name="videoCcId" value="${prodVideo.videoCcId}" /></td>
					</tr>
					<tr>
						<td>
							<span>JS代码:</span>
						</td>
						<td>
							<textarea style="height:100px;width:350px;" name="videoCcJscode">${prodVideo.videoCcJscode}</textarea>
						</td>
				    </tr>
					<tr>
					    <td><span>排序值:</span></td>
					    <td>
					        <select name="seq">
					            <option value="">请选择</option>
					            <#list 1..5 as num>
					            <option value="${num}" <#if num == prodVideo.seq>selected</#if>>${num}</option>
					            </#list>
					        </select>
					    </td>
					</tr>
					<tr>
					    <td><span>产品ID:</span></td>
					    <td><#if prodVideo.childObjectId ??>${prodVideo.childObjectId}<#else>${prodVideo.objectId}</#if></td>
					</tr>
					<tr>
					    <td><span>产品类别:</span></td>
					    <td>${prodVideo.categoryName}</td>
					</tr>
					<tr>
					    <td><span>视频来源:</span></td>
					    <td><#if prodVideo.childObjectId ??>获取打包产品视频<#else>添加视频</#if></td>
					</tr>
				</table>
			  </form>
			</div>
		</#list>
		<#if prodVideoList?size gt 0>
		    <div style="width:800px;">
	             <a class="btn btn_cc1" style="width:120px;;border-radius:5px;background-color:#4d90fe;border-color:#4d90fe;color:#fff !important;margin-left:550px;" id="saveBatch" href="javascript:void(0);">保存</a>
            </div>
		</#if>	
	</div>
</div>
<#include "/base/foot.ftl">
</body>
</html>

<script>
	var addDialog = {},productId = ${productId},categoryId =${categoryId};
	$("#btnAddVideo").bind("click", function() {
		if($(".dataform").length>=5){
	       alert("视频数量不得超过5个");
	       return;
	    }
		addDialog = new xDialog("/vst_admin/prod/prodVideo/showAddProductVideo_local.do",{"productId": ${productId}, "categoryId": ${categoryId}}, {title: "添加视频", width: 900});
	});
	
	$("#getChildVideo").bind("click",function(){
	    $("#iframeMain",window.parent.document).attr("src", "/vst_admin/prod/prodVideo/showProductVideo_local.do?productId="+ ${productId} + "&categoryId=" + ${categoryId} +"&childVideo=Y");
	});
	
	$("#saveBatch").bind("click",function(){
	    if($(".dataform").length>5){
	       alert("视频数量不得超过5个");
	       return;
	    }
	    
	    var flag=true;
	    
	    $("input[name='videoCcId']").each(function(){
	       if($(this).val() == "" || $(this).val() == null){
	          alert("存在视频未填写ID");
	          flag=false;
	       }
	    });
	    if(flag==false){
	       return;
	    }
	    
	    $("textarea[name='videoCcJscode']").each(function(){
	       if($(this).val() == "" || $(this).val() == null){
	          alert("存在视频未填写JS代码");
	          flag=false;
	       }
	    });
	    if(flag==false){
	       return;
	    }
	    
	    $("select[name='seq']").each(function(){
	       if($(this).val() == "" || $(this).val() == null){
	          alert("存在视频未设置排序值");
	          flag=false;
	       }
	    });
	    if(flag==false){
	       return;
	    }
	    var param = [];
	    $(".dataform").each(function(){
	        var serializeObj = {};
	        var array = $(this).serializeArray();
	        $(array).each(function(){ 
                 serializeObj[this.name]=this.value;
	        });
	        param.push(serializeObj);
	    });
	    $.ajax({
	       url:"/vst_admin/prod/prodVideo/saveBatchVideo.do",
	       type:"post",
	       data:{"datajson":JSON.stringify(param)},
	       success:function(result){
	          if(result.success == true){
	              $.alert("保存成功",function(){
	                  $("#productVideo_local",window.parent.document).parent("li").click();
	              });
	          }else{
	              $.alert("保存失败");
	          }
	       },
	       error:function(e){
	          $.alert("系统异常");
	       }
	    });
	});
	
	function updateProductVideo(e){
		var msg = "确定修改吗?", objelement = null,that = e;
		var postdata = {
			objectId: ${productId},
			fieldModify:null};
		
		e = window.event || arguments.callee.caller.arguments[0] || e;
		objelement = e.target || e.srcElement; // Chrome || IE
		postdata.videoID = objelement.getAttribute("data-id");
		
		// 删除
		if(objelement.tagName == "BUTTON"){
			msg = "确定删除吗?";
			postdata.fieldModify = "status"; 
			postdata.status = '-1'; // -1为删除
			if(e && e.preventDefault){
				e.preventDefault();
			}else{
				window.event.returnValue = false;//注意加window
			}
		}
		
		if(postdata.videoID == "" || postdata.videoID == null){
		   $(that).parents(".video").remove();
		   return;
		}
		
		$.confirm(msg, function() {
			$.ajax({
				url: "/vst_admin/prod/prodVideo/updateProductVideo_local.do",
				type: "post",
				data: postdata,
				success: function(data) {
					var result = data.success;
					var msg = data.message;
					if(result == true) {
						$.alert(msg, function() {
							window.location.reload();
						});
					}else{
						$.alert(msg);
					}
				},
				error: function(e) {
					$.alert(e);
				}
			});
		});
	}
</script>
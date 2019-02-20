<!DOCTYPE html>
<html>
<head>
<style>
.videocontent *{
	display:inline-block;
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
	<#if showError??>
		<div class="tiptext tip-warning cc5">
		<span class="tip-icon tip-icon-warning"></span>说明：
		<#if showError == "17">
			<p class="pl15">添加视频的限制条件：商品基础设置-BU【目的地事业部】</p>
		<#elseif showError =="18">
			<p class="pl15">添加视频的限制条件：商品基础设置-类别【国内】；BU【目的地事业部】；</p>
		</#if>
	</div>
	<#else>
	<div class="tiptext tip-warning cc5">
		<span class="tip-icon tip-icon-warning"></span>说明：
		<p class="pl15">1.一个产品可添加多个视频，系统调取排序值为1的视频加载到图片播放位；调取剩余排序值第2-4个视频加载到产品详情顶部；</p>
		<p class="pl15">2.可通过设置排序值调整视频顺序，排序值为0，或者状态为无效，不参与露出排序，排序值输入框只支持0,1,2,3...自然数输入。</p>
	</div>
	
	<div class="p_box box_info clearfix">
	        <h2 class="f16 mb10">视频管理
	        	<a class="btn btn_cc1" style="float:right;margin-right:50%;" id="btnAddVideo" href="javascript:void(0);">添加视频</a>	
	        </h2>
	        
	</div>

<!-- 主内容显示区域 -->
	<div>
		<#list prodVideoList as prodVideo>
			<div class="videotitle" style="margin:20px 0px 20px 20px">
				<table width="100%">
					<tr>
						<td width="100px"><b>视频${prodVideo_index + 1}</b></td>
						<td width="300px"><b>ID:</b> ${prodVideo.videoCcId}</td>
						<td width="200px"><b>产品ID:</b> ${prodVideo.objectId}</td>
						<td><b>产品类别:</b>${prodVideo.categoryName}</td>
						<td width="260px"><b <#if prodVideo.status =="1">style="color:red;font-weight:bold;"</#if>>排序值</b><input type="text" data-id="${prodVideo.videoID}" onchange="updateProductVideo(this);" style="margin-left:10px" value="${prodVideo.seq}" name="seq" /></td>
					</tr>
					<tr>
						<td colspan="4">
							<textarea style="width:98%;height:100px;" data-id="${prodVideo.videoID}" onchange="updateProductVideo(this);">${prodVideo.videoCcJscode}</textarea>
						</td>
						<td>
								<button class="btn" data-id="${prodVideo.videoID}" onclick="updateProductVideo(this)">删除</button>
						</td>
				</table>
			</div>
		</#list>
	</div>
	</#if>
<div>

<#include "/base/foot.ftl">
</body>
</html>

<script>
	var addDialog = {},productId = ${productId},categoryId =${categoryId};
	$("#btnAddVideo").bind("click", function() {
		addDialog = new xDialog("/vst_admin/prod/prodVideo/showAddProductVideo.do",{"productId": ${productId}, "categoryId": ${categoryId}}, {title: "添加视频", width: 900});
	});
	
	function updateProductVideo(e){
		var msg = "确定修改吗?", objelement = null;
		var postdata = {
			objectId: ${productId},
			fieldModify:null};
		
		e = window.event || arguments.callee.caller.arguments[0] || e;
		objelement = e.target || e.srcElement; // Chrome || IE
		postdata.videoID = objelement.getAttribute("data-id");
		
		// 修改视频内容
		if(objelement.tagName == "TEXTAREA") {
			postdata.fieldModify = "videoCcJscode";
			postdata.videoCcJscode = objelement.value;
		}
		
		if(objelement.tagName == "INPUT") {
			// 排序
			if(objelement.type  == "text") {
				if(isNaN(objelement.value)){
					$.alert("排序值必须为数字");return;
				}
				postdata.fieldModify = "seq";
				postdata.seq = objelement.value;
			}
		}
		
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
		
		$.confirm(msg, function() {
			$.ajax({
				url: "/vst_admin/prod/prodVideo/updateProductVideo.do",
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
		}, function() {
			window.location.reload();
		});
	}
</script>
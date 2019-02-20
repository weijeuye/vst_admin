<form enctype="multipart/form-data" method="post">
<input type="hidden" value="${productId!''}" name="objectId" />
<input type="hidden" value="${categoryId!''}" name="bizCategoryId" />

	<div class="dialog-content clearfix" data-content="content">
		<div class="p_box box_info p_line">
			<div class="box_content ">
				<p><i class="cc1">*</i>请输入视频ID</p>

				<p><input type="text" class="w100" name="videoCcId" id="videoCcId"/> <span id="freebieNameWarn"	class="hidden">赠品名称不能为空,请勿输入下列字符 <> % # * & ^ @ ! ~ /\</span></p>
				
				<p><i class="cc1">*</i>请贴入播放代码</p>
				
				<textarea style="height: 80px" name="videoCcJscode" id="videoCcJscode" class="w100"></textarea>
				
				<p><i class="cc1">*</i>排序值</p>
				
				<p><input type="text" value="0" name="seq" id="seq"/></p>
				
			</div>
		</div>
	</div>
	
	<div class="p_box box_info clearfix mb20">
		<div class="fl operate"><a class="btn btn_cc1" id="save">保存</a></div>
	</div>
</form>

<script>
	
	$("#save").bind("click", function() {
		if($("#videoCcId").val() == "") {
			$.alert("视频ID未填");
			return;
		}
		
		if($("#videoCcJscode").val() == "") {
			$.alert("播放代码未填");
			return;
		}
		
		if($("#seq").val() == "") {
			$.alert("排序值未填");
			return;
		}
		
		if(isNaN($("#seq").val())){
			$.alert("排序值必须为数字");
			return;
		}
	
		var jsondata = {
			objectId:$("[name='objectId']").val(), 
			bizCategoryId: $("[name='bizCategoryId']").val(), 
			videoCcId: $("[name='videoCcId']").val(), 
			videoCcJscode: $("[name='videoCcJscode']").val(),
			photoUrl: $("[name='photoUrl']").val(),
			seq: $("[name='seq']").val()
		};
		
		$.ajax({
			type:"post",
			url: "/vst_admin/prod/prodVideo/addProductVideo.do",
			dataType: "json",
			async: false,
			data: jsondata,
			success: function(data) {
				var result = data.success;
				var msg = data.message;
				if( result == true) {
					$.alert(msg, function() {
						window.location.href = "/vst_admin/prod/prodVideo/showProductVideo_local.do?productId=${productId!''}&categoryId=${categoryId!''}";
					});
				} else {
					$.alert(msg);
				}
			},
			error: function(e) {
				$.alert(e.message);
			}
		});
	
	});
</script>
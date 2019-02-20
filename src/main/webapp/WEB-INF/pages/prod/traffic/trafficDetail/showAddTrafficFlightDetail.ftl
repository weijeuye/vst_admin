<div style="height:350px">
<form action="/vst_admin/prod/traffic/showAddTrafficFlightDetail.do" method="post" id="dataForm" class="dataForm">
		<input type="hidden" name="productId" value="${traffic.productId}">
        <table class="p_table form-inline">
            <tbody>
            	<#if traffic.toType!=null&&traffic.backType!=null>
                <tr>
                	<td class="">往返-去程</td>
                </tr>
                <tr>
                	<td class="">直飞/中转:<select id="transfer_go"><option value="1">直飞</option><option value="2">1程中转</option></select></td>
                </tr>
                <tr>
                	<td class="">航班号：<input type="text" name="prodTrafficFlightList[0].flightNo" class="toType"></td>
                	<input type="hidden" name="prodTrafficFlightList[0].tripType" value="TO">
                </tr>
                <tr class="moreFlight" style="display:none">
                	<td class="">航班号：<input type="text" name="prodTrafficFlightList[1].flightNo" class="toType" disabled="disabled"></td>
                	<input type="hidden" name="prodTrafficFlightList[1].tripType" value="TO" disabled="disabled">
                </tr>
                <tr>
                	<td class="">往返-返程</td>
                </tr>
                 <tr>
                	<td class="">直飞/中转:<select id="transfer_back"><option value="1">直飞</option><option value="2">1程中转</option></select></td>
                </tr>
                <tr>
                	<td class="">航班号：<input type="text" name="prodTrafficFlightList[2].flightNo" class="backType"></td>
                	<input type="hidden" name="prodTrafficFlightList[2].tripType" value="BACK">
                </tr>
                <tr class="moreFlight" style="display:none">
                	<td class="">航班号：<input type="text" name="prodTrafficFlightList[3].flightNo" class="backType" disabled="disabled"></td>
                	<input type="hidden" name="prodTrafficFlightList[3].tripType" value="BACK" disabled="disabled">
                </tr>
                <#else>
                <tr>
                	<td class="">单程</td>
                </tr>
                <tr>
                	<td class="">直飞/中转：<select id="transfer"><option value="1">直飞</option><option value="2">1程中转</option></select></td>
                </tr>
                <tr>
                	<td class="">航班号：<input type="text" name="prodTrafficFlightList[0].flightNo" class="toType"></td>
                	<input type="hidden" name="prodTrafficFlightList[0].tripType" value="TO">
                </tr>
                <tr class="moreFlight" style="display:none">
                	<td class="">航班号：<input type="text" name="prodTrafficFlightList[1].flightNo" class="toType" disabled="disabled"></td>
                	<input type="hidden" name="prodTrafficFlightList[1].tripType" value="TO" disabled="disabled">
                </tr>
                </#if>
            </tbody>
        </table>
</form>
<div class="p_box box_info clearfix mb20">
     <div class="fl operate" style="margin-top:20px;"><a class="btn btn_cc1" id="save">保存</a></div>
</div>
</div>
<script> 
	$(".toType,.backType").each(function(){
			vst_pet_util.commListSuggest($(this),$("form"),'/vst_admin/prod/traffic/searchFlightNoList.do','');
			
	});
	
	$("#save").click(function(){
				try{
					$(".toType,.backType").each(function(){
						if(!$(this).is(":hidden")){
							if($(this).val()==""){
								throw "请输入航班信息";
							}
						}
					});
				}catch(e){
					$.alert(e);
					return;
				}
				
				$.ajax({
					url : "/vst_admin/prod/traffic/addTrafficFlightDetail.do",
					type : "post",
					data : $("#dataForm").serialize(),
					success : function(result) {
							if(result.code=='success'){
								$.alert("保存成功",function(){
										$("#traffic",parent.document).parent("li").trigger("click");
								});
							}else if(result.code=='error'){
							  $.alert('输入有误,航班号不存在<br>请重新输入或先在航班管理中添加该航班');
							}else{
								$.alert("保存失败");
							}
					}
				});
	});
	//往返程添加 
	$("#transfer_go").change(function(){
		var value = $(this).val();
		if(value=="2"){
			$(".moreFlight:eq(0)").show();
			$(".moreFlight:eq(0)").find("input").removeAttr("disabled");
			
		}else {
			$(".moreFlight:eq(0)").hide();
			$(".moreFlight:eq(0)").find("input").attr("disabled","disabled");
		}
	});
	
	$("#transfer_back").change(function(){
		var value = $(this).val();
		if(value=="2"){
			$(".moreFlight:eq(1)").show();
			$(".moreFlight:eq(1)").find("input").removeAttr("disabled");
			
		}else {
			$(".moreFlight:eq(1)").hide();
			$(".moreFlight:eq(1)").find("input").attr("disabled","disabled");
		}
	});
	
	//单程修添加
	$("#transfer").change(function(){
		var value = $(this).val();
		if(value=="2"){
			$(".moreFlight:eq(0)").show();
			$(".moreFlight:eq(0)").find("input").removeAttr("disabled");
		}else {
			$(".moreFlight:eq(0)").hide();
			$(".moreFlight:eq(0)").find("input").attr("disabled","disabled");
		}
	});
</script>

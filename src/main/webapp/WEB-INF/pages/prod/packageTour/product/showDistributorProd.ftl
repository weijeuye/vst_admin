<#assign thisSubCategoryId= 0 />
<#if prodProduct??>
	<#if prodProduct.subCategoryId??>
		<#assign thisSubCategoryId= prodProduct.subCategoryId />
	</#if>
	<#if prodProduct.productType ?? && prodProduct.productType == 'FOREIGNLINE'>
		<#if prodProduct.bizCategoryId==15
			|| prodProduct.bizCategoryId==16
			|| prodProduct.bizCategoryId==18
			|| prodProduct.bizCategoryId==17>
			<input type="hidden" id="foreignline1255" value="Y">
		</#if>
	</#if>	
<#else>
	<#if subCategoryId??>	
		<#assign thisSubCategoryId= subCategoryId />
	</#if>	
</#if>
	<div class="title" data="subCategoryId=${subCategoryId},prodProduct.subCategoryId=<#if prodProduct??>${prodProduct.subCategoryId}</#if>,bizCategory.categoryId=${bizCategory.categoryId},thisSubCategoryId=${thisSubCategoryId}">
	   <h2 class="f16">销售渠道</h2>
	</div>
	 <div class="box_content">
        <table class="e_table form-inline">
            <tbody>
                <tr>
                	<td class="e_label"><i class="cc1">*</i></td>
                	<td>
                		<input type="checkbox" errorEle="code"   id="distributorIds_selectAll"/>全选
                		<#list distributorList as list>
                			<#assign distributorIdDisplay="" />
                			<#if bizCategory?? && bizCategory.categoryId==18 && thisSubCategoryId==184 && list.distributorId==4>
                			<!-- 巴士+酒 不展示分销商 -->
                				<#assign distributorIdDisplay="none" />
                			</#if>
                			<#assign distributorId=0 />
                			<#assign categoryId= 0 />
                			<#if bizCategory??>
                			<#assign categoryId= bizCategory.categoryId />
                			</#if>
                			<!-- 产品已有销售渠道展示 -->
                			<#if prodProduct?? && prodProduct.distDistributorProds?? && prodProduct.distDistributorProds?size &gt; 0>
                				<#list prodProduct.distDistributorProds as distDistributorProd>
                					<#if list.distributorId==distDistributorProd.distributorId>    
                						<#if list.distributorId==10 || list.distributorId==20>
                								
                							<#if  prodProduct.bizCategoryId==15 || prodProduct.bizCategoryId==16  || prodProduct.bizCategoryId==18
                							|| prodProduct.bizCategoryId==8 || prodProduct.bizCategoryId == 17>
                								<span style="display:${distributorIdDisplay};">
               										<input type="checkbox" checked="checked" required=true errorEle="code" data1="distributor_item" name="distributorIds" onclick="distributorIdsCheck(this)" id="distributorIds_${list.distributorId!''}" value="${list.distributorId!''}"  />
               										${list.distributorName!''}
               										<#assign distributorId=list.distributorId />
                								</span>
                							</#if>
                						<#else>
                								<span style="display:${distributorIdDisplay};">
                									<input type="checkbox" checked="checked" required=true errorEle="code" data1="distributor_item" name="distributorIds" onclick="distributorIdsCheck(this)" id="distributorIds_${list.distributorId!''}" value="${list.distributorId!''}"  />
                									${list.distributorName!''}
                									<#assign distributorId=list.distributorId />
                								</span>
                						</#if>                					
                					</#if>
                				</#list>
                			</#if>
                			<!-- 销售渠道列表展示 -->
                			<#if distributorId!=list.distributorId>
                				<#if  list.distributorId==10>
                								<!-- 如果品类为线路显示 门店销售渠道-->
                							<#if  categoryId == 15||categoryId==16||categoryId==18 ||categoryId==8 || categoryId == 17>
                									<span id="distributor_mendian"> 
               										<input type="checkbox" errorEle="code" required=true name="distributorIds"  data1="distributor_item"  id="distributorIds_${list.distributorId!''}"  onclick="distributorIdsCheck(this)" value="${list.distributorId!''}"  />
        											${list.distributorName!''}
        											</span>
                							</#if>
                				<#elseif list.distributorId==20>
                							<!-- 如果品类为线路显示 门店app销售渠道-->
                							<#if  categoryId == 15||categoryId==16||categoryId==18 ||categoryId==8|| categoryId == 17>
                									<span id="distributor_mendian_app"> 
               										<input type="checkbox" errorEle="code" required=true name="distributorIds"  data1="distributor_item"  id="distributorIds_${list.distributorId!''}"  onclick="distributorIdsCheck(this)" value="${list.distributorId!''}"  />
        											${list.distributorName!''}
        											</span>
                							</#if>			
                				<#else>
                						<span style="display:${distributorIdDisplay};">
                								<input type="checkbox" errorEle="code" required=true name="distributorIds" data1="distributor_item"  id="distributorIds_${list.distributorId!''}" onclick="distributorIdsCheck(this)" value="${list.distributorId!''}"  />
        										${list.distributorName!''} 
        								</span>
                				</#if>
        						              				
                			</#if>
		                </#list>  
		                 <div id="codeError" style="display:inline"></div>              	
                	</td>
                </tr>
                <!-- 巴士+酒 不展示分销商 -->
            	<tr id="distributorUserIdstr" <#if bizCategory?? && bizCategory.categoryId==18 && thisSubCategoryId==184>style="display:none;"</#if>>
					<td class="e_label">super系统分销商</td>
					<td >
						<#if tntGoodsChannelVo?? && tntGoodsChannelVo.channels?? && tntGoodsChannelVo.channels?size &gt; 0>
							<!--渠道遍历-->
							<#list tntGoodsChannelVo.channels as tntChannelVo>
								<!--分销商遍历-->
								<#if  tntChannelVo.users?? && tntChannelVo.users?size &gt; 0>
									<#list tntChannelVo.users as tntUserVo>
											<input type="checkbox" errorEle="code"  name="distributorUserIds"   id="distributorUserIds_${tntUserVo.userId}" data="${tntChannelVo.channelId}"
											 	<#if userIdLongStr != null && userIdLongStr?index_of(",${tntUserVo.userId},") != -1>checked="checked"</#if>
												value="${tntChannelVo.channelId + "-" + tntUserVo.userId!''}"  onclick="fillName(this)" /> ${tntUserVo.userName!''}
											
											 <!--用于日志 -->
											<input type="checkbox"  name="distUserNames" style="display:none" id="${tntChannelVo.channelId + "-" + tntUserVo.userId!''}" data="${tntChannelVo.channelId}"
											    <#if userIdLongStr != null && userIdLongStr?index_of(",${tntUserVo.userId},") != -1>checked="checked"</#if>
											  value="${tntUserVo.userName!''}"  /> 
											 
									</#list>
								<#elseif tntChannelVo.channelId?? && tntChannelVo.channelIdStr == "0">
									<input type="checkbox" errorEle="code"  name="distributorUserIds"  data="${tntChannelVo.channelId}"
										<#if userIdLongStr != null && userIdLongStr?index_of("0-0") != -1>checked="checked"</#if> value="0-0"/>其他
								</#if>
							</#list>
						</#if>
					</td>
				</tr>
       		</tbody>
       	</table>
   	</div>

<script>

//分销商名称复选框的勾选与取消勾选
function fillName(val1){
  var distUserId=val1.value;
  if(val1.checked==false){
     $("#"+distUserId).removeAttr("checked");
  }else{
     $("#"+distUserId).attr("checked","checked");
  }
}

function checkAddPrice(){
    //门店渠道暂不支持设置过酒店新加价规则的产品
	if(($("#distributorIds_10").attr("checked") == "checked" && $("#distributorIds_10").attr("disabled") != "disabled") 
	   || ($("#distributorIds_20").attr("checked")=="checked" && $("#distributorIds_20").attr("disabled") != "disabled") 
	   || $("#distributorUserIds_0").attr("checked")=="checked"){
	   if($("#validNewHotelPriceRule").val() == "true"){
	       return true;
	   }else{
	       return false;
	   }
	}
	return false;
}

//加载页面，渠道已选择分销(distributorId=4)
var distributorChecked = document.getElementById("distributorIds_4").checked;
if(!distributorChecked){
	//默认展示，未选中就隐藏
	$("#distributorUserIdstr").find("input[type=checkbox]").attr("disabled","disabled");
}else if($("input[autopack='auto_pack_traffic']:checked").val() == 'Y'){
      $("#distributorUserIds_967").removeAttr("disabled");
      $("#distributorUserIds_968").removeAttr("disabled");
	}else{
	$("#distributorUserIdstr").find("input[type=checkbox]").removeAttr("disabled");
}
//产品维护页面加载后，如果打包类型不为供应商类型，不显示门店销售渠道
var initialType = $("input[name=packageTypeTD]:checked").val();
var subCategoryId = $("#subCategoryId").val();
var categoryId = $("#categoryId").val();
if(initialType =='SUPPLIER'||categoryId == 15 ||(categoryId == 18 && subCategoryId != "183")){
	$("#distributor_mendian").show();
	$("#distributor_mendian_app").show();
	$("#distributor_mendian").find("input").attr("disabled",false);
	$("#distributor_mendian_app").find("input").attr("disabled",false);
}else if(initialType =='LVMAMA'){
	$("#distributor_mendian").hide();
	$("#distributor_mendian_app").hide();
	$("#distributor_mendian").find("input").attr("disabled",true);
	$("#distributor_mendian_app").find("input").attr("disabled",true);
}
//打包类型为供应商时展示门店销售渠道
$("input:radio[name='packageType']").live("change",function(){
	var isCheck=$('input:radio[name="packageType"]:checked').val();
	if(isCheck=='SUPPLIER'||categoryId == 15 ||(categoryId == 18 && subCategoryId != "183")){
		$("#distributor_mendian").show();
		$("#distributor_mendian_app").show();
		$("#distributor_mendian").find("input").attr("disabled",false);
		$("#distributor_mendian_app").find("input").attr("disabled",false);
	}else if(isCheck=='LVMAMA'){
		$("#distributor_mendian").hide();
		$("#distributor_mendian_app").hide();
		$("#distributor_mendian").find("input").attr("disabled",true);
		$("#distributor_mendian_app").find("input").attr("disabled",true);
	}
});
//渠道选择分销展示和隐藏下行分销商操作
function distributorIdsCheck(obj){
	if(obj.value == 4){
		if(!obj.checked){
			$("#distributorUserIdstr").find("input[type=checkbox]").attr("disabled","disabled");
		}else{
			if($("input[autopack='auto_pack_traffic']:checked").val() == 'Y'){
			  	$("#distributorUserIds_967").removeAttr("disabled");
		     	$("#distributorUserIds_968").removeAttr("disabled");
			}else{
				$("input[name=distributorUserIds]").removeAttr("checked");
				$("#distributorUserIdstr").find("input[type=checkbox]").removeAttr("disabled");
			}
			if($("#foreignline1255").length > 0){
				if($("#distributorUserIds_967").length > 0){
					 $("#distributorUserIds_967").attr("checked","checked");
                    fillName($("#distributorUserIds_967").get(0));
				}
				if($("#distributorUserIds_968").length > 0){
					 $("#distributorUserIds_968").attr("checked","checked");
                    fillName($("#distributorUserIds_968").get(0));
				}
				if($("#distributorUserIds_0").length > 0){
					 $("#distributorUserIds_0").attr("checked","checked");
                    fillName($("#distributorUserIds_0").get(0));
				}						
			}else if($("select[name=productType] option:selected").val() == 'FOREIGNLINE'){
				if($("#distributorUserIds_967").length > 0){
					 $("#distributorUserIds_967").attr("checked","checked");
                    fillName($("#distributorUserIds_967").get(0));
				}
				if($("#distributorUserIds_968").length > 0){
					 $("#distributorUserIds_968").attr("checked","checked");
                    fillName($("#distributorUserIds_968").get(0));
				}
				if($("#distributorUserIds_0").length > 0){
					 $("#distributorUserIds_0").attr("checked","checked");
                    fillName($("#distributorUserIds_0").get(0));
				}	
			}else if($('input:radio[name="productType"]:checked').val() == 'FOREIGNLINE'){
				if($("#distributorUserIds_967").length > 0){
					 $("#distributorUserIds_967").attr("checked","checked");
                    fillName($("#distributorUserIds_967").get(0));
				}
				if($("#distributorUserIds_968").length > 0){
					 $("#distributorUserIds_968").attr("checked","checked");
                    fillName($("#distributorUserIds_968").get(0));
				}
				if($("#distributorUserIds_0").length > 0){
					 $("#distributorUserIds_0").attr("checked","checked");
                    fillName($("#distributorUserIds_0").get(0));
				}			
			}			
		}
	}
	//驴妈妈前台选中
	if(obj.value == 3){
		if(obj.checked){
			//特卖会没被选中并且门店和门店app选中
            var $temaihui = $("#distributorUserIds_972");
			if($temaihui && !$temaihui.prop("checked")){
                if($("#distributorIds_10")){
                    $("#distributorIds_10").attr("checked","checked");
                }
                if($("#distributorIds_20")){
                    $("#distributorIds_20").attr("checked","checked");
                }
			}

			var distributorUserIds_107_Checked = "";
			$("input[name=distributorUserIds]").each(function(){
				var data = $(this).attr("data");
				var thisChecked = $(this).attr('checked');
				if(data == "107" && thisChecked =='checked'){
					distributorUserIds_107_Checked = "checked";
				}else{
				}
			});
			if(distributorUserIds_107_Checked =='checked'){
				alert("销售渠道互斥：驴妈妈前台与特卖会渠道不能同时选中");
				obj.checked=false;
				return;
			}
		}
	}
	//门店选中，门店APP也选中
	if(obj.value == 10){
		if(obj.checked){
			if($("#distributorIds_20")){
				$("#distributorIds_20").attr("checked","checked");
			}
		}
	}
	//门店APP选中，门店选中
	if(obj.value == 20){
		if(obj.checked){
			if($("#distributorIds_10")){
				 $("#distributorIds_10").attr("checked","checked");
			}
		}
	}
}

$("input[name=distributorUserIds]").each(function(index){
	$(this).click(function(){
		var data = $(this).attr("data");
		var thisChecked = $(this).attr('checked');
		var distributorIds_3_Checked = $("#distributorIds_3").attr('checked');
		 if(distributorIds_3_Checked =='checked'){
			 if($("#distributorIds_10").size()>0){
				 $("#distributorIds_10").attr("checked","checked");
			 }
			 if($("#distributorIds_20").size()>0){
				 $("#distributorIds_20").attr("checked","checked");
			 }		 
		 }
		if(data == "107" && thisChecked =='checked'){
			if(distributorIds_3_Checked =='checked'){
				alert("销售渠道互斥：驴妈妈前台与特卖会渠道不能同时选中");
				$(this).removeAttr('checked');
                fillName($(this).get(0));
				return;
			}
		}
		
		if(data == "107"){
			var isChecked = $(this).is(':checked');
            if(confirm("特卖会渠道勾选与取消需通知特卖会运营操作及排查，否则产品不能正常售卖!是否继续操作？")){
                $(this).attr('checked',isChecked);
            }else{
                $(this).attr('checked',!isChecked);
            }
		}
 	});
});

</script>
<script>

//检查前台与特卖会互斥
function checkMutex(){
	
	var distributorUserIds_107_Checked = "";
	$("input[name=distributorUserIds]").each(function(){
		var data = $(this).attr("data");
		var thisChecked = $(this).attr('checked');
		if(data == "107" && thisChecked =='checked'){
			distributorUserIds_107_Checked = "checked";
		}
	});
	//互斥-false
	if(distributorUserIds_107_Checked =='checked'){
		return false;
	}else{
		return true;
	}
}

if($("input[type=checkbox][data1=distributor_item]").size()==$("input[type=checkbox][data1=distributor_item]:checked").size()){
		if(!checkMutex()){
			alert("销售渠道互斥：驴妈妈前台与特卖会渠道不能同时选中");
		}else{
			$("#distributorIds_selectAll").attr("checked","checked");
		}
}

  //设置week选择,全选
$("#distributorIds_selectAll").click(function(){
	if($(this).attr("checked")=="checked"){
		var y = checkMutex();
		if(!checkMutex()){
			alert("销售渠道互斥：驴妈妈前台与特卖会渠道不能同时选中");
			$("#distributorIds_selectAll").removeAttr("checked");
		}else{
			$("input[type=checkbox][data1=distributor_item]").attr("checked","checked");
			$("#distributorUserIdstr").find("input[type=checkbox]").removeAttr("disabled");
			if($("#foreignline1255").length > 0){
				if($("#distributorUserIds_967").length > 0){
					 $("#distributorUserIds_967").attr("checked","checked");
				}
				if($("#distributorUserIds_968").length > 0){
					 $("#distributorUserIds_968").attr("checked","checked");
				}
				if($("#distributorUserIds_0").length > 0){
					 $("#distributorUserIds_0").attr("checked","checked");
				}						
			}else if($("select[name=productType] option:selected").val() == 'FOREIGNLINE'){
				if($("#distributorUserIds_967").length > 0){
					 $("#distributorUserIds_967").attr("checked","checked");
				}
				if($("#distributorUserIds_968").length > 0){
					 $("#distributorUserIds_968").attr("checked","checked");
				}
				if($("#distributorUserIds_0").length > 0){
					 $("#distributorUserIds_0").attr("checked","checked");
				}	
			}else if($('input:radio[name="productType"]:checked').val() == 'FOREIGNLINE'){
				if($("#distributorUserIds_967").length > 0){
					 $("#distributorUserIds_967").attr("checked","checked");
				}
				if($("#distributorUserIds_968").length > 0){
					 $("#distributorUserIds_968").attr("checked","checked");
				}
				if($("#distributorUserIds_0").length > 0){
					 $("#distributorUserIds_0").attr("checked","checked");
				}			
			}				
		}
	}else {
		$("input[type=checkbox][data1=distributor_item]").removeAttr("checked");
		$("#distributorUserIdstr").find("input[type=checkbox]").attr("disabled","disabled");
	}
})

//设置week选择,单个元素选择
$("input[type=checkbox][data1=distributor_item]").click(function(){
	if($("input[type=checkbox][data1=distributor_item]").size()==$("input[type=checkbox][data1=distributor_item]:checked").size()){
		if(!checkMutex()){
			alert("销售渠道互斥：驴妈妈前台与特卖会渠道不能同时选中");
		}else{
			$("#distributorIds_selectAll").attr("checked","checked");
		}
	}else {
		$("#distributorIds_selectAll").removeAttr("checked");
	}
});


</script>

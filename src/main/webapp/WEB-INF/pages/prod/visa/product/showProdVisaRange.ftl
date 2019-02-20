<div class="p_box" style="overflow:scroll;height: 600px;">
<form action="/vst_admin/visa/range/updateProdVisaRange.do" method="post" id="dataForm">
		<input type="hidden" name="productId" <#if prodVisaRange?? && prodVisaRange.productId??>value="${prodVisaRange.productId}"</#if>> 
		<input type="hidden" name="rangeId" <#if prodVisaRange?? && prodVisaRange.rangeId??>value="${prodVisaRange.rangeId}"</#if>> 
        <table class="p_table form-inline">
            <tbody>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>所属领区：</td>
                	<td colspan=2>
                		<select name="rangeCity" id="rangeCity" required>
                    	 			<option value="">请选择</option>
		    						<#list dictExtendList as list>
		    							<option value=${list.dictId!''} <#if prodVisaRange!=null && prodVisaRange.rangeCity==list.dictId>selected</#if>>${list.dictName!''}</option>
			                </#list>
			        	</select>
                	</td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>受理范围：</td>
                	<td colspan=2>
                		<textarea class="w35 textWidth" required style="width:700px; height:80px" maxlength=2000 id="area" name="area"><#if prodVisaRange?? && prodVisaRange.area??>${prodVisaRange.area!''}</#if></textarea>
                	</td>
                </tr>
                <#if prodVisaRangeDistReList?? && (prodVisaRangeDistReList?size &gt; 0)>
	                <#list prodVisaRangeDistReList as prodVisaRangeDistRe>
	                <tr <#if prodVisaRangeDistRe_index=0>name='no1'</#if>>
	                	<#if prodVisaRangeDistRe_index=0>
				   		<td name="addspan" rowspan=${prodVisaRangeDistReList?size} class="e_label"><i class="cc1">*</i>目的地：</td>
				   		</#if>
			            <td colspan=2>
			            	<input type="text" name="district" id="district${prodVisaRangeDistRe_index}" errorEle="district" value="${prodVisaRangeDistRe.districtName}" readonly = "readonly" required>
			            	<input type="hidden" name="prodVisaRangeDistReList[${prodVisaRangeDistRe_index}].districtId" id="districtId${prodVisaRangeDistRe_index}" value="${prodVisaRangeDistRe.districtId}">
			            	<input type="hidden" name="prodVisaRangeDistReList[${prodVisaRangeDistRe_index}].reId" id="reId" value="${prodVisaRangeDistRe.reId}">
			            	<input type="hidden" name="prodVisaRangeDistReList[${prodVisaRangeDistRe_index}].productId" value="${prodVisaRangeDistRe.productId}">
			            	<#if prodVisaRangeDistRe_index=0><a class="btn btn_cc1" name="new_button2">添加行政区</a>
			            	<#else><a class='btn btn_cc1' name='del_button'>删除</a>
			            	</#if>
			            	<div id="districtError" style="display:inline"></div>
			            </td>
	        	    </tr>
	                </#list>
                 <#else>
                	<tr name='no1'>
	                	<td name="addspan" rowspan=1 class="p_label"><i class="cc1">*</i>行政区划：</td>
	                 	<td colspan=2>
	                    	<input type="text" errorEle="district" name="district" id="district0" readonly = "readonly" required>
	                    	<input type="hidden" name="prodVisaRangeDistReList[0].districtId" id="districtId0" >
	                    	<a class="btn btn_cc1" name="new_button2">添加行政区</a>
	                    	<div id="districtError"></div>
	                    </td>
	                </tr>
	        	 </#if> 
            </tbody>
        </table>
</form>
</div>
<div class="p_box box_info clearfix mb20">
	<div class="fl operate" style="margin-top:10px;"><a class="btn btn_cc1" id="save">保存</a></div>
</div>
<script>
	isView();
	
	var count = <#if prodVisaRangeDistReList?? && (prodVisaRangeDistReList?size &gt; 0)> 
					${prodVisaRangeDistReList?size-1};
				<#else>
					0;
				</#if>
	var markDistrict;
	var markDistrictId;
		//打开选择行政区窗口
		$("input[name=district]").die().live("click",function(){
			console.log(1111111);
			$(this).parents("td").find("div").remove();
			markDistrict = $(this).attr("id");
			markDistrictId = $(this).next().attr("id");
			districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do",{},{title:"选择行政区",iframe:true,width:"1000",height:"600"});
		});
//选择行政区
function onSelectDistrict(params){
   		var flag = true;
		if(params!=null){
			$("input[name=district]").each(function(){
				if($(this).next().val() == params.districtId){
				 	flag = false;
				}
			}); 
			console.log(flag);
			if(flag){
				$("#"+markDistrict).val(params.districtName);
				$("#"+markDistrictId).val(params.districtId);
				if($("#"+markDistrict).next().is("i")){
					$("#"+markDistrict).next().remove();
				}
			}else{
				$.alert("同一产品下目的地不能重复！");
			}
		}
		districtSelectDialog.close();
}

	//删除目的地
	$("a[name=del_button]").die().live("click",function(){
		if($(this).parents("tr").attr("name")=="no1"){
			var $td = $(this).parents("tr").children("td:first");
			$(this).parents("tr").next().prepend($td);
			$(this).parents("tr").next().attr("name","no1");
			$(this).parents("tr").next().children("td:last").append("<a class='btn btn_cc1' id='new_button2'>添加目的地</a>")
		}
		
		$(this).parents("tr").remove();
		var rows = $("input[name=district]").size();
		$("td[name=addspan]").attr("rowspan",rows);
	});
	
	//新建目的地
	$("a[name=new_button2]").die().live("click",function(){
		var flag = true;
		console.log(flag);
		$("input[name=district]").each(function(){
			var districtValue;
			if($(this).next().is("i")){
				districtValue = $(this).next().next().val();
			}else{
				districtValue = $(this).next().val();
			}
			if(typeof(districtValue) =="undefined" || districtValue ==""){
			 	flag = false;
			}
		}); 
		
		if(flag == false){
			$.alert("请先填充空的目的地。");
			return;
		}
		count++;
		var rows = $("input[name=district]").size();
		$("td[name=addspan]").attr("rowspan",rows+1);
		var $tbody = $(this).parents("tbody");
		$tbody.children("tr:last").after("<tr><td><input type='text' name='district' id='district"+count+"' readonly = 'readonly' required><input type='hidden' name='prodVisaRangeDistReList["+count+"].districtId' id='districtId"+count+"'/><a class='btn btn_cc1' name='del_button'>删除</a></td></tr>"); 
	});


$(function(){
	$(".textWidth[maxlength]").each(function(){
		var	maxlen = $(this).attr("maxlength");
		if(maxlen != null && maxlen != ''){
			var l = maxlen*12;
			if(l >= 700) {
				l = 700;
			} else if (l <= 200){
				l = 200;
			} else {
				l = 400;
			}
			$(this).width(l);
		}
		$(this).keyup(function() {
				vst_util.countLenth($(this));
		});
	});
});
$("#save").bind('click',function(){
	//验证
			if(!$("#dataForm").validate({
			}).form()){
				return false;
			}
		  var msg = '是否保存?';	
		  if(refreshSensitiveWord($("input[type='text'],textarea"))){
		 	 msg = '内容含有敏感词,是否继续?';
		  }
		  //$("#save").hide(); 
		  $.confirm(msg,function(){
				$.ajax({
					url : "/vst_admin/visa/range/updateProdVisaRange.do",
					type : "post",
					data : $(".dialog #dataForm").serialize(),
					success : function(result) {
						if(result.code=='success'){
							$.alert(result.message,function(){
								location.href="/vst_admin/visa/range/findProdVisaRangeList.do?productId="+$("#productId").val()+"&categoryId="+$("#categoryId").val();
				   			});
						}else{
							$.alert(result.message);
							$("#save").show();
						}
					},
					error : function(){
						$("#save").show();
					}
				});
			}, function(){
				$("#save").show();
			});

});
	refreshSensitiveWord($("input[type='text'],textarea"));


</script>
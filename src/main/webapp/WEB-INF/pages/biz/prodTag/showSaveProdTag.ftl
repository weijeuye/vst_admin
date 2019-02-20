<!DOCTYPE html>
<html>
<head>
</head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline">
			<tbody>
				<tr>
					<input type="hidden" id="tagId" name="tagId" value=<#if bizTag??>${bizTag.tagId}</#if>>
					<td class="p_label" width="100px;"><i class="cc1">*</i>小组名称：</td>
                	<td colspan=2>
                		<div>
	                		<select id="tagGroup" name="tagGroupId" required>
							  	<option value="">请选择</option>
							  	<#if tagGroups?? && tagGroups?size gt 0>
		                    		<#list tagGroups as tagGroup>
										<option value="${tagGroup.tagGroupId}">${tagGroup.tagGroupName}</option>
		                    		</#list>
	                    		</#if>
		                	</select>
                	   </div>
                	</td>
				</tr>
				<tr>
					<td class="p_label"><i class="cc1">*</i>标签名称：</td>
					<td colspan=2>
                		<div>
	                		<select id="tagName" name="tagName" required>
		                	</select>
		                	<input id="selectTagName" required style="display:none"/>
                	   </div>					
					</td>
				</tr>
				<tr>
					<td class="p_label"><i class="cc1">*</i>标签有效期：</td>
					<td colspan=2>
						<input type="text" name="startTime" errorEle="code" class="Wdate" id="startDate" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'endDate\',{d:0});}'})" required />
						——
						<input type="text" name="endTime" errorEle="code" class="Wdate" id="endDate" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'startDate\',{y:2});}',readOnly:true,minDate:'#F{$dp.$D(\'startDate\',{d:0});}'})" required />
						<!-- <div id="codeError" style="display:inline"></div> -->
					</td>
				</tr>
				<tr>
					<td class="p_label"><i class="cc1">*</i>标签显示位置：</td>
					<td colspan=2>
						<input id="ck1" type="checkbox" value="PC端" checked="checked"/>PC端
						<input id="ck2" type="checkbox" value="无线端" style="margin-left:100px" checked="checked"/>无线端
						<input id="displaytype" name="displaytype" required style="display:none" value="2">
					</td>
				</tr>
			</tbody>
		</table>
		<div class="fl operate" style="margin:20px;width: 700px;" align="center">
			<input type="hidden" value="${prodTagVO.objectId}" name="objectIds" id="objectIds"/>
			<input type="hidden" value="${prodTagVO.objectType}" name="objectType" id="objectType"/>
			<a class="btn btn_cc1" id="saveOrUpdate">提交</a>
			<a class="btn btn_cc1" id="cancel">取消</a>
		</div>		
	</form>
	
	<form id="saveDataForm">
	</form>
</body>
</html>
	<script type="text/javascript" src="/vst_admin/js/loading.js"></script>
	<script>
	
	   // 创建表单元素
	   function createItem(name,value){
     	   $("#saveDataForm").append('<input type=hidden name='+name+' value='+value+'>');
	   }
	   
	   
		$(function(){
			
			// 新增与修改
			$('#saveOrUpdate').bind('click',function(){
			
				$("#displaytype").val('');
			 	if($("#ck1").is(':checked') && !$("#ck2").is(':checked')){
			 		$("#displaytype").val(1);
			 	}
			 	if(!$("#ck1").is(':checked') && $("#ck2").is(':checked')){
			 		$("#displaytype").val(2);
			 	}
			 	if($("#ck1").is(':checked') && $("#ck2").is(':checked')){
			 		$("#displaytype").val(3);
			 	}
			 	
			 	
			 	var tagGroupName = $('#tagGroup').find("option:selected").text()
				if('品牌'==tagGroupName) {
					createItem('isBrandTagGroup', true);
				} else {
					createItem('isBrandTagGroup', false);
				}
				
				var url = '/vst_admin/biz/prodTag/saveProdTag.do';
				$("#selectTagName,#displaytype").show();
				//验证
				if(!$("#dataForm").validate({
					rules : {
						tagGroupId:{
							required : true
						},
						tagName:{
							required : true
						},
						startDate:{
							required : true
						},
						endDate:{
							required : true
						}
					}
				}).form()){
					$("#selectTagName, #displaytype").hide();
					return false;
				} 
				$("#selectTagName,#displaytype").hide();
				
				var startDate = $('#startDate').val();
				var endDate = $('#endDate').val();
				if(startDate>endDate){
					$.alert("标签有效期开始日期不能大于结束日期！");
					return false;
				}				
				// 清空表单
				$('#saveDataForm').empty();
				
				
				var objectIds = $('#objectIds').val();
				if(objectIds.length<=0){
					 $("input[type=checkbox][name=objectIds]:checked").each(function(){
					 	 var value = $(this).val();
						 createItem('objectIds',value);
					 });
					 url = '/vst_admin/biz/prodTag/saveBatchProdTag.do'
				}else{
					createItem('objectId',objectIds);
				}
			
				// 开始时间
				var startDate = $('#startDate').val();
				createItem('startTime',startDate);			
				
				// 结束时间
				var endDate = $('#endDate').val();
				createItem('endTime',endDate);
				
				// 小组名称
				var tagGroupId = $('#tagGroup').val();
				createItem('tagGroupId',tagGroupId);
				
				// 标签名称
				var tagName = $('#selectTagName').val();
				createItem('tagName',tagName);
				
				// 对象类型
				var objectType = $('#objectType').val();				
				createItem('objectType',objectType);
				
				//显示位置类型
				var displaytype = $('#displaytype').val();
				createItem('displaytype',displaytype);
				
				var msg = '确定新增';
				$.confirm(msg,function(){
					startLoading('正在保存，请稍候...');
					$.ajax({
						url : url,
						type : "post",
						data : $("#saveDataForm").serialize(),
						success : function(result) {
							completeLoading();
							if(result.code=='success'){
					 	 	 	 $.alert(result.message,function(){
					 	 	 	 	search();
					   				addDialog.close();	
					 	 	 	 });
					 	 	 }else{
								$.alert(result.message, function(){
								
									addDialog.close();	
								});			 	 	 
					 	 	 }
						}
					});				
				});
			});
			
			// 取消
			$('#cancel').bind('click',function(){
				addDialog.close();	
			});
			
			$('#tagGroup').bind('change',function(){
				$("#selectTagName").val('');
				findAllTagNameByGroup();
			});
			
			findAllTagNameByGroup();			
		})
		
		// 根据小组名称查询标签
		function findTagNameByGroup(){
			var tagGroupId = $('#tagGroup').val();
			$('#saveDataForm').empty();
			createItem('tagGroupId',tagGroupId);
			$.ajax({
				url : "/vst_admin/biz/bizTag/findTagNameByGroup.do",
				type : "post",
				async: false,
				data : $("#saveDataForm").serialize(),
				success : function(result) {
					$('#tagName').empty();
					$('#tagName').append("<option value=\'\'>请选择</option>");
					$.each(result,function(index,data){
						$('#tagName').append("<option value=\'"+data.tagName+"\'>"+data.tagName+"</option>");
					});
				},
				error : function(result) {
					$.alert(result.message);
				}
			});		
		}	
		
		// 根据小组名称查询有效标签
		function findAllTagNameByGroup(){
		
			$('#tagName').combobox({  
	            url : "/vst_admin/biz/bizTag/findAllTagNameByGroup.do?iniAll="+encodeURIComponent(encodeURIComponent('请选择'))+"&tagGroupId=" + $('#tagGroup').val(),
	            valueField:'tagValue',  
	            textField:'tagName',
	            filter: function(q, row){
	                var opts = $(this).combobox('options');
	                return row[opts.textField].match(q);
	            }, 
	            onLoadSuccess:function(){
	            	var tagName = $("#selectTagName").val();
	            	if(tagName != ''){
	            		$('#tagName').combobox('setValue',tagName).combobox('setText',tagName);
	            	}else{
	            		$('#tagName').combobox('setText','请选择');
	            	}
	            }, 
	            onLoadError:function(){
	            	$.alert(result.message);
	            },
	            onChange: function (n,o){
	            	if(n==''){
	            		$("i[for=selectTagName]").show();
	            	}else{
	            		$("i[for=selectTagName]").hide();
	            	}
	            	$("#selectTagName").val(n);
	            }       
	     	});
		}
		
	</script>
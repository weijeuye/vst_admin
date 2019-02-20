<!DOCTYPE html>
<html>
<head>
</head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline">
			<tbody>
				<tr>
					<td class="p_label" width="100px;">小组名称：</td>
                	<td colspan=2>
                		<div id="showTagGroup" style="display:block" class="divTagGroup">
	                		<select id="tagGroup" name="tagGroupId">
							  	<option value="">请选择</option>
							  	<#if tagGroups?? && tagGroups?size gt 0>
		                    		<#list tagGroups as tagGroup>
		                    			<option value="${tagGroup.tagGroupId}">
		                    				${tagGroup.tagGroupName}
		                    			</option>
		                    		</#list>
	                    		</#if>
		                	</select>
		                	
		                	<!--
		                	<span><input type="radio" value="addTagGroup" name="tagGroupName"/>
	                			修改小组名称	                			
	                		<span>
	                		-->
	                		
                	   </div>
                	   <!--
                	   <div id="showTagName" style="display:none" class="divTagGroup">
	                		<input type="text" maxlength="20" name="addTagGroup" id="addTagGroup"/>
	                		<span><input type="radio" value="selectTagGroup" name="tagGroupName"/>选择已有小组名称<span>
                	    <div>
                	    -->
                	</td>
				</tr>
				<tr>
					<td class="p_label">标签描述：</td>
					<td colspan=2>
						<textarea class="w35 textWidth" style="width: 500px; height: 80px;" id="memo" name="memo" maxlength="120"></textarea>
					</td>
			   </tr>
				<tr>
			   		<td class="p_label">标签状态：</td>
					<td>
                        <label class="radio mr10">
                        	<input type="radio" id="cancelFlag" name="cancelFlag" value='Y' checked="checked">有效
                        </label>
                        <label class="radio mr10">
                        	<input type="radio" id="cancelFlag" name="cancelFlag" value='N'>无效	
                        </label>
                    </td>
			   </tr>
			</tbody>
		</table>
		<div class="fl operate" style="margin:20px;width: 700px;" align="center">
			<a class="btn btn_cc1" id="batchUpdate">提交</a>
			<a class="btn btn_cc1" id="cancel">取消</a>
		</div>		
	</form>	
</body>
</html>
	<script>
	
	   // 创建表单元素
	   function createItem(name,value){
     	   $("#dataForm").append('<input type=hidden name='+name+' value='+value+'>');
	   }
	   
	
		$(function(){
			
			//限制字数
			$(".textWidth[maxlength]").each(function() {
				var	maxlen = $(this).attr("maxlength");
				if(maxlen != null && maxlen != ''){
					var l = maxlen*12;
					if(l >= 700) {
						l = 500;
					} else if (l <= 200){
						l = 200;
					} else {
						l = 200;
					}
					$(this).width(l);
				}
				$(this).keyup(function() {
					vst_util.countLenth($(this));
				});
			});	
			
			// 修改
			$('#batchUpdate').bind('click',function(){
							
				var url = '/vst_admin/biz/bizTag/saveBatchUpdateBizTag.do';
				
				//清空以前的objectIds
				var objectIds = document.getElementsByTagName("objectIds");
				for (var i = 0; i < objectIds.length; i++) {
					document.body.removeChild(objectIds[i]);
				}
				//重新创建objectIds										
				$("input[type=checkbox][name=objectIds]:checked").each(function(){
				 	 var value = $(this).val();
					 createItem('objectIds',value);
				});
								
				var msg = '确定修改';
				$.confirm(msg,function(){
					$.ajax({
						url : url,
						type : "post",
						data : $("#dataForm").serialize(),
						success : function(result) {
							if(result.code=='success'){
					 	 	 	 $.alert(result.message,function(){
					 	 	 	 	search();
					   				showAddOrUpdate.close();	
					 	 	 	 });
					 	 	 }else{
								$.alert(result.message);			 	 	 
					 	 	 }
						}
					});				
				});
			});
			
			// 取消
			$('#cancel').bind('click',function(){
				showAddOrUpdate.close();	
			})						
		})
							
	</script>
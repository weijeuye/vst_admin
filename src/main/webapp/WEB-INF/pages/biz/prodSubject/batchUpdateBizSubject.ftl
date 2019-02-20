<!DOCTYPE html>
<html>
<head>
</head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline">
			<tbody>
				<tr>
			   		<td class="p_label"><i class="cc1">*</i>状态：</td>
					<td>
                        <label class="radio mr10">
                        	<input type="radio" id="cancelFlag" name="cancelFlag" value='Y' required=true>有效
                        </label>
                        <label class="radio mr10">
                        	<input type="radio" id="cancelFlag" name="cancelFlag" value='N' required=true>无效	
                        </label>
                    </td>
			   </tr>
			</tbody>
		</table>
		<div class="fl operate" style="margin:20px;width: 400px;" align="center">
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
			// 修改
			$('#batchUpdate').bind('click',function(){

				if(!$("#dataForm").validate().form()){
					return false;
				}
											
				var url = '/vst_admin/biz/bizSubject/saveBatchUpdateBizSubject.do';
				
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
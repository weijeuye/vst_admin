<!DOCTYPE html>
<html>
<head>
</head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline">
			<tbody>
				<tr>
                    <input type="hidden" id="tagId" name="tagId" value="<#if bizTag??>${bizTag.tagId}</#if>" />
			   		<td class="p_label">SEQ值：</td>
					<td>
                        <input id="seq" maxlength="5" type="number" name="seq" value="<#if bizTag??>${bizTag.seq}</#if>" />
                    </td>
			   </tr>
			</tbody>
		</table>
		<div class="fl operate" style="margin:20px;width: 400px;" align="center">
			<a class="btn btn_cc1" id="updateSeq">保存</a>
		</div>
	</form>	
</body>
</html>
	<script>
	
		$(function(){
			// 修改
			$('#updateSeq').bind('click',function(){

                /**
                 * 验证整数或验证非零的负整数
                 */
                jQuery.validator.addMethod("isMinus1", function(value, element) {
                    var chars =  /^[0-9]\d*$/;// 验证正整数
//                    var rq =  /^\-[1-9][0-9]*$/;// 验证非零的负整数
                    return this.optional(element) || chars.test(value);
                }, "只能填写整数");

                if(!$("#dataForm").validate({
                            rules : {
                                seq:{
                                    isMinus1 : true
                                }
                            }
						}).form()){
                    return false;
                }

                if($("#seq").val()==""){
                    $.alert('请输入SEQ值');
                    return false;
                }

				$.ajax({
					url : '/vst_admin/biz/bizTag/saveBizTagSeq.do',
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
			
		})
							
	</script>
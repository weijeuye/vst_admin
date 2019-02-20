<form id="dataForm">
	<input type="hidden" name="destId" value="${bizDestSearch.destId!''}">
	<input type="hidden" name="id" value="${bizDestSearch.id!''}">
    <table class="p_table form-inline">
        <tbody>
            <tr>
            	<td class="p_label">
            		目的地
            	</td>
                <td>
                	<input type="checkbox"  id="useFlag" name="useFlag" value="${bizDestSearch.useFlag!''}" <#if bizDestSearch.useFlag == 'Y'>checked<#else></#if>>
                	搜索不用
                </td>
                <td class="p_label">
                	目的地层级
                </td>
                <td>
	        		<select name="destLevel" id="destLevel">
    					<option value="1" ${(bizDestSearch.destLevel == 1)?string("selected", "")}>一级</option>
    					<option value="2" ${(bizDestSearch.destLevel == 2)?string("selected", "")}>二级</option>
    					<option value="3" ${(bizDestSearch.destLevel == 3)?string("selected", "")}>三级</option>
    					<option value="4" ${(bizDestSearch.destLevel == 4)?string("selected", "")}>四级</option>
    					<option value="5" ${(bizDestSearch.destLevel == 5)?string("selected", "")}>五级</option>
		        	</select>                
                </td>
			</tr>
        </tbody>
    </table>
</form>
<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="editDestSearchButton">保存</button>
<script>
$("input[type=checkbox][name=useFlag]").bind("click",function(){
	if ($(this).is(':checked')) {
		$(this).val("Y");
	} else {
		$(this).val("");
	}
});

//修改目的地搜索设置
$("#editDestSearchButton").bind("click",function(){
	//验证
	if(!$("#dataForm").validate().form()){
		return;
	}
	$.confirm("确认修改吗 ？", function (){
		$.ajax({
			url : "/vst_admin/biz/dest/manageDestSearch.do",
			type : "post",
			dataType:"json",
			async: false,
			data : $("#dataForm").serialize(),
			success : function(result) {
			   if(result.code=="success"){
					$.alert(result.message,function(){
		   				editDestSearchDialog.close();
		   			});
				}else {
					$.alert(result.message);
		   		}
			}
		});	
	});					
});
</script>

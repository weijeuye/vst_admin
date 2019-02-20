<form id="dataForm">
        <table class="p_table form-inline">
            <tbody>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>玩法名称：</td>
                    <td><input type="text" id="name" name="name" required=true>15个字以内
                    <div id="destNameError"></div>
                    </td>
                </tr> 
                <tr>
                    <td class="p_label"><i class="cc1">*</i>玩法拼音：</td>
                    <td>
                    	<input type="text" id="pinyin" name="pinyin" required=true>
                    </td>
                </tr>
                <tr>
                    <td class="p_label" ><i class="cc1">*</i>所属品类：</td>
                    <td>
                        <#list categoryList as category> 
	                    	<input type="radio" name="categoryId" value=${category.categoryId!''} required />${category.cnName!''}
		                </#list>
                    </td>
                </tr>
                <tr id="sub_category">
				   	<td class="p_label"><i class="cc1">*</i>所属上级：</td>
                    <td>
                    	<select name="subCategoryId" id="subCategoryId">
                    	    <option value="">请选择</option>
                	        <#list subCategoryList as subCategory> 
		                    	<option value=${subCategory.categoryId!''}>${subCategory.categoryName!''}</option>
			                </#list>
                    	</select>
                    </td>
                 </tr>   
                 <tr>
				   	<td class="p_label">是否标红：</td>
                    <td>
                    	<select name="redFlag" id="redFlag">
	                    	<option value="">请选择</option>
	                    	<option value='Y'<#if redFlag == 'Y'>selected</#if>>是</option>
					        <option value='N'<#if redFlag == 'N'>selected</#if>>否</option>
                    	</select>
                    </td>
                 </tr> 
                 <tr>
				   	<td class="p_label">状态：</td>
                    <td>
                    	<select name="validFlag" id="validFlag">
	                    	<option value="">请选择</option>
	                    	<option value='Y'<#if validFlag == 'Y'>selected</#if>>有效</option>
				            <option value='N'<#if validFlag == 'N'>selected</#if>>无效</option>
                    	</select>
                    </td>
                 </tr> 
                <tr>
                	<td></td>
                     <td>
                        <button class="pbtn pbtn-small btn-ok" style="float:left" id="addButton">保存</button>
                    </td> 
                </tr> 
            </tbody>
        </table>
</form>
 <script>
 
 //添加目的地
$("#addButton").bind("click",function(){

	$.ajax({
	url : "/vst_admin/show/playMethod/addPlayMethod.do",
	type : "post",
	dataType:"json",
	async: false,
	data : $("#dataForm").serialize(),
	success : function(result) {
	  console.log(result);
	   if(result.code=="success"){
			addMethodDialog.close();
			location.reload();
		}else {
			$.alert(result.message);
   		}
	   }
	});						
});

//当选择其他票，所属上级显示，否则不显示
$("input[name='categoryId']").bind("change",function(){
   $("#sub_category").hide();
   $("input[name='categoryId']").each(function(){
	     if($(this).val()==12 && $(this).is(":checked")){
	      $("#sub_category").show();
	     }
   })
});

//根据输入的中文名称自动补全拼音
$("#name").change(function(){
   if($.trim($(this).val()).length > 15){
    $("#name").val("");
   	$.alert("不能超过15个字符。");
    return;
   }
   if($.trim($(this).val()) != ""){
		$("#pinyin").val(vst_pet_util.convert2pinyin($(this).val()));
   }
});

function RepNumber(obj) {
var reg = /^[\d]+$/g;
if (!reg.test(obj.value)) {
var txt = obj.value;
txt.replace(/[^0-9]+/, function (char, index, val) {//匹配第一次非数字字符
obj.value = val.replace(/\D/g, "");//将非数字字符替换成""
var rtextRange = null;
if (obj.setSelectionRange) {
obj.setSelectionRange(index, index);
} else {//支持ie
rtextRange = obj.createTextRange();
rtextRange.moveStart('character', index);
rtextRange.collapse(true);
rtextRange.select();
}
})
}
}
 </script>

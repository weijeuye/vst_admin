<div class="iframe_search">
<input type="hidden" id="suggCode" name="suggCode" value="${suggCode!''}">
<#if groupList?? && groupList?size &gt; 0>
    <table class="p_table form-inline">
        <tbody>
            <#list groupList as group> 
				<table id="tab${group.groupId!''}">
				<tr>
					<td>
						<h1>${group.groupName!''}:</h1>
						<p>${group.groupTitle!''}:
						<#if group.selectType == 2 >
							 <label>全选<input name="checkall" type="checkbox"/></label>
							 </#if>
					</td>
				</tr>
				<#list detailMap?keys as key>
					<#if key==group.groupId>
						<#assign details = detailMap[key]>
						<#list details as detail>
							 <tr>
							 	<td>
							 		<#if group.selectType==1>
							 			<input type="radio"  id="${detail.detailId}" name="dName${key}"   titlename="${group.groupTitle!''}">
							 		<#elseif group.selectType==2>
							 			<input type="checkbox" id="${detail.detailId}" name="dName${key}"  titlename="${group.groupTitle!''}">
							 		</#if>
							 		<span id="td${detail.detailId}">${detail.suggDesc!''}</span>
							 	</td>
							 </tr>
						</#list>
					</#if>
				</#list>
				</table>
			</#list>
        </tbody>
    </table>
    <button class="pbtn pbtn-small btn-ok" style="float:middle;margin-top:20px;" id="saveButton">确认</button>
<#else>
 无条款，请先维护！
</#if>
    
</div>
<script>
var numb=1;
$("#saveButton").bind("click",function(){
	$(this).attr("disabled","disabled");
	var str="";
	// 选中的行id
    $("input[name^='dName']").each(function(){
    	if($(this).attr("checked")){
    		str += $(this).attr("id")+",";
        }
    });
	// 选中的行对象
	var detailIds = str.split(",");
	var resultStr = "";
	var currentTitle= "";
	for (var i=0; i < detailIds.length; i++) {
		var detailId = detailIds[i];
		if (detailId == '')
			continue;
		var html = $.trim($("#td" + detailId).html());
		var title=$("#"+detailId).attr("titlename");
		var detailNum = $("input[name^='txt" + detailId + "']").length;
		var result = "";
		if(currentTitle != title){
			 currentTitle = title;
			 resultStr +=currentTitle+ "\n";
			 numb=1;
		}
		if (detailNum == 0) { // 纯文字，没有 text 框
			result += numb+"."+html + $.trim($("#td" + detailId).val())+"\n";
			numb++;
		} else {
			for (var j=0; j< detailNum; j++) {
			    var m=0;
				while(html.indexOf("<")>0){
                    var txtId = "txt" + detailId + "_" + m;
                    var txtVal = $("#" + txtId).val();
                    var inputStartIndex = html.indexOf('<');
                    var inputEndIndex = html.indexOf('>');

					if(inputStartIndex != 0 && inputEndIndex !=0){
						result += html.substr(0, inputStartIndex);
                    }

                    if (txtVal != null && txtVal != '') {
                        result += "(" + txtVal + ")";
                        txtVal="";
                    }
                    html = html.substr(inputEndIndex+1);
                    m++;
                }
			}
			result += html;
			result = numb+"."+result + "\n";
			numb++; 
		}
		resultStr += result;
	}
		
	if(resultStr == null || resultStr == ''){
		alert("请选择条款");
		$(this).removeAttr("disabled");
		return;
	}
	setSuggTextArea(resultStr);
});

//复选框全选或者全不选
$(function(){

$("[name=checkall]").click(function(){
var all = $(this);
 var flag = $(this).attr("checked",$(this).checked);
 var items = $(this).closest("table").find("input[type=checkbox]").not("[name=checkall]");
 if(!flag){
 	items.attr("checked",false);
 }else{
 	items.attr("checked",true);
 }
 items.click(function(){
 
 $(this).each(function(){
 
if(items.filter(":checked").length == items.length) {
	 all.attr("checked",this.checked);
}else{
	 all.attr("checked",false);
}
 });
 
 });
 
});

});

</script>
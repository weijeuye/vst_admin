<#include "/base/findDictInputType.ftl"/>
<form  id="dataForm">
    <table class="p_table form-inline">
        <tbody>
     		<tr> 
    			<input id="dictDefId" type="hidden" name="dictDefId" value="${dictDef.dictDefId!''}">
    			<input id="dictId" type="hidden" name="dictId" value="${bizDict.dictId!''}">
     		</tr>
            <tr>
            	<td class="p_label">字典定义ID：</td>
                <td>${dictDef.dictDefId!''}</td>
            </tr>
            <tr>
            	<td class="p_label"><span class="notnull">*</span>酒店名称：</td>
                <td><textarea  id="dictName" name="dictName" required=true style="width: 330px; height: 58px;">${bizDict.dictName!''}</textarea></td>
            </tr>
            <!-- 字典属性list -->
        	<#assign index=0 />
            <#list dictPropDefList as dictPropDef>
            <tr>
                <td class="p_label"><#if dictPropDef.nullFlag == 'Y' && dictPropDef.cancelFlag=='Y'><span class="notnull">*</span></#if>${dictPropDef.dictPropDefName!''}：</td>
            	<td width='150'>
            	<input id="${dictPropDef.dictPropDefId}" type="hidden"/>
           			<!-- 开始通用组件 -->
		            <@displayHtml index dictPropDef />
		            <!-- 字典定义属性Id -->
                	<input id="dictPropDefId" type="hidden" name="dictPropList[${index}].dictPropDefId" value="${dictPropDef.dictPropDefId!''}">
                	<!--  字典定义Id -->
                	<input id="dictDefId" type="hidden" name="dictPropList[${index}].dictDefId" value="${dictPropDef.dictDefId!''}">
                	<!-- 字典Id -->
        			<input id="dictId" type="hidden" name="dictPropList[${index}].dictId" value="${dictPropDef.bizDictProp.dictId!''}">
                	<!-- 字典属性Id -->
                	<input id="dictPropId" type="hidden" name="dictPropList[${index}].dictPropId" value="${dictPropDef.bizDictProp.dictPropId!''}"/>
            	</td>
              
               </tr>
               <#assign index = index+1 />
			</#list> 
        </tbody>
    </table>
</form>

<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="addButton">保存</button>
<script>
var dataObj=[],markList=[];
	
	$(".sensitiveVad").each(function(){
		var mark=$(this).attr('mark');
	 	var t = lvmamaEditor.editorCreate('mark',mark);
	 	dataObj.push(t);
	 	markList.push(mark);
	});
//给产品ID赋值并设置为不可编辑
$("#50").next("input").attr("readonly","readonly");

//给产品ID赋值并设置为不可编辑
var districtSelectDialog;
//选择行政区
$("#51").next("input").attr("readonly","readonly");
function onSelectDistrict(params){
	if(params!=null){
		$("#51").next("input").val(params.districtName);
		$("#districtId").val(params.districtId);
	}
	districtSelectDialog.close();
}

//打开选择行政区窗口
$("#51").next("input").click(function(){
	districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do?type=main",{},{title:"选择行政区",iframe:true,width:"1000",height:"600"});
});

function validateSensitiveVad(){
    var ret = true;
    
    $("textarea.sensitiveVad").each(function(index,element){
        var required = $(element).attr("required");
        var str = $(element).text();
        if(required==="required"&&str.replace("<br />","")===""){
            alert("请填写完必填项再保存");
            ret= false;
        }
        
        var len = str.match(/[^ -~]/g) == null ? str.length : str.length + str.match(/[^ -~]/g).length ;
        var maxLength = $(element).attr("maxLength");
        if(len>maxLength){
            alert("超过最大长度"+maxLength);
            ret= false;
        }
    });
    return ret;
}

$("#addButton").bind("click",function(){
	$(this).attr("disabled","disabled");
	for(var i=0;i<dataObj.length;i++){
		var temp = dataObj[i].html();
		$(".sensitiveVad").filter("[mark="+markList[i]+"]").text(temp);
	}
	//验证
	if (!$("#dataForm").validate({
			rules : {
				dictDefName : {
					isChar : true
				},
				dictName : {
					isChar : true
				}
			},
			messages : {
				dictDefName : '不可输入特殊字符',
				dictName : '不可输入特殊字符'

			}
		}).form()) {
			$(this).removeAttr("disabled");
			return false;
		}
	
	if(!validateSensitiveVad()){
        return false;
    }

		//遮罩层
		var loading = pandora.loading("正在努力保存中...");

		$.ajax({
			url : "/vst_admin/biz/changeHotel/updateChangeHotel.do?branchId=${branchId}",
			type : "post",
			dataType : 'json',
			data : $("#dataForm").serialize(),
			success : function(result) {
				loading.close();
				$("#addButton").removeAttr("disabled");
				if (result.code == "success") {
					$.alert(result.message);
					fillHotel(result.hotelId,result.hotelName,'N');
					updateChangeHotelDialog.close();
				} else {
					$.alert(result.message);
				}
			},
			error : function() {
				$("#addButton").removeAttr("disabled");
				loading.close();
				updateChangeHotelDialog.close();
			}
		});

	});
</script>

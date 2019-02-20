<!DOCTYPE html>
<html>
<head>

</head>
<body>
<form id="dataForm">
    <table class="p_table form-inline">
        <tbody>
            <tr>
                <td class="p_label"><i class="cc1">*</i>航班号：</td>
                <td><input type="text" id="flightNo" name="flightNo" required="true" value="${bizFlight.flightNo}"/>&nbsp;&nbsp;<button class="pbtn pbtn-small btn-ok" id="syncButton">同步</button></td>
                <td class="p_label"><i class="cc1">*</i>航空公司：</td>
                <td>
                    <input type="text" class="searchInput" id="airlineString" name="airlineString" value="${bizFlight.airlineString!''}" required="true"  errorele="searchValidate"/>
                    <input type="hidden" id="airline" name="airline" value="${bizFlight.airline!''}"/>
                </td>
            </tr>
            <tr>
                <td class="p_label"><i class="cc1">*</i>始发机场：</td>
                <td>
                    <input type="text" class="searchInput" id="startAirportString" name="startAirportString"  value="${bizFlight.startAirportString!''}" required="true" errorele="searchValidate"/>
                    <input type="hidden" id="startAirport" name="startAirport" value="${bizFlight.startAirport!''}">
                </td>
                <td class="p_label"><i class="cc1">*</i>到达机场：</td>
                <td>
                    <input type="text" class="searchInput" id="arriveAirportString" name="arriveAirportString" value="${bizFlight.arriveAirportString!''}" required="true" errorele="searchValidate"/>
                    <input type="hidden" id="arriveAirport" name="arriveAirport" value="${bizFlight.arriveAirport!''}">
                </td>
            </tr>
            <tr>
                <td class="p_label">始发机场航站楼：</td>
                <td>
                    <input type="text" id="startTerminal" name="startTerminal" value="${bizFlight.startTerminal!''}">
                </td>
                <td class="p_label">到达机场航站楼：</td>
                <td>
                    <input type="text" id="arriveTerminal" name="arriveTerminal" value="${bizFlight.arriveTerminal!''}">
                </td>
            </tr>
            <tr>
                <td class="p_label"><i class="cc1">*</i>出发城市：</td>
                <td>
                    <input type="text" id="startDistrictString" name="startDistrictString" errorele="searchValidate" class="searchInput" readonly="readonly" required="true" value="${bizFlight.startDistrictString!''}"/>
                    <input type="hidden" id="startDistrict" name="startDistrict" value="${bizFlight.startDistrict!''}">
                </td>
                <td class="p_label"><i class="cc1">*</i>抵达城市：</td>
                <td>
                    <input type="text" id="arriveDistrictString" name="arriveDistrictString" errorele="searchValidate" class="searchInput" readonly="readonly" required="true" value="${bizFlight.arriveDistrictString!''}"/>
                    <input type="hidden" id="arriveDistrict" name="arriveDistrict" value="${bizFlight.arriveDistrict!''}">
                </td>
            </tr>
            <tr>
                <td class="p_label"><i class="cc1">*</i>起飞时间：</td>
                <td>
                    <input errorEle="searchValidate" type="text" name="startTime" class="Wdate w110" id="d4321" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" value="${bizFlight.startTime!''}"/>
                </td>
                <td class="p_label"><i class="cc1">*</i>降落时间：</td>
                <td>
                    <input errorEle="searchValidate" type="text" name="arriveTime" class="Wdate w110" id="d4322" onFocus="WdatePicker({readOnly:'true',dateFmt:'H:mm'})" value="${bizFlight.arriveTime!''}"/>
                 </td>
            </tr>
            <tr>
                <td class="p_label">经停次数：</td>
                <td>
                    <select id="stopCount" name="stopCount">
                        <option value=""></option>
                        <#list 0..3 as time>
                            <#if time == bizFlight.stopCount>
                                <option value="${time}" selected="selected">${time}</option>
                            <#else>
                                <option value="${time}">${time}</option>
                            </#if>
                        </#list>
                    </select>
                </td>
                <td class="p_label">机型：</td>
                <td>
                    <input type="text" id="airplaneString" class="searchInput"  name="airplaneString" value="${bizFlight.airplaneString!''}"  errorele="searchValidate"/>
                    <input type="hidden" id="airplane" name="airplane" value="${bizFlight.airplane}"/>
                </td>
            </tr>
            <tr>
                <td class="p_label">飞行时长：</td>
                <td>
                    <select id="flightTimeHour" name="flightTimeHour" class="w6">
                        <option value=""></option>
                        <#list 0..23 as hour>
                            <#if hour == bizFlight.flightTimeHour>
                                <option value="${hour}" selected="selected">${hour}</option>
                            <#else>
                                <option value="${hour}">${hour}</option>
                            </#if>
                        </#list>
                    </select>
                                                            小时
                    <select id="flightTimeMinute" name="flightTimeMinute" class="w6">
                        <option value=""></option>
                        <#list 0..59 as minute>
                            <#if minute == bizFlight.flightTimeMinute>
                                <option value="${minute}" selected="selected">${minute}</option>
                            <#else>
                                <option value="${minute}">${minute}</option>
                            </#if>
                        </#list>
                    </select>
                                                            分钟
                </td>
                <td class="p_label">共享航班号：</td>
                <td>
                    <input type="text" id="shareFlightNo" name="shareFlightNo" value="${bizFlight.shareFlightNo}">
                </td>
            </tr>
        </tbody>
    </table>
    <input type="hidden" id="cancelFlag" name="cancelFlag" value="Y">
    <input type="hidden" id="flightId" name="flightId" value="${bizFlight.flightId}">
</form>
<button class="pbtn pbtn-small btn-ok" style="float: right; margin-top: 20px;" id="saveButton">保存</button>

<script>
var districtSelectDialog;
$(document).ready(function(){

    //选择出发城市
    $("#startDistrictString").on('click', function(){
        districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do",{id:"startDistrict"},{title:"选择出发城市",iframe:true,width:"1000",height:"600"});
    });
    
    //选择抵达城市
    $("#arriveDistrictString").on('click', function(){
        districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do",{id:"arriveDistrict"},{title:"选择抵达城市",iframe:true,width:"1000",height:"600"});
    });
    
    //选择城市
    function onSelectDistrict(params){
        if(params != null){
            var districtName = params.districtName;
            var districtId = params.districtId;
            if(districtSelectDialog.data.id === "startDistrict"){
                $("#startDistrictString").val(districtName);
                $("#startDistrict").val(districtId);
            } else {
                $("#arriveDistrictString").val(districtName);
                $("#arriveDistrict").val(districtId);
            }
        }
        districtSelectDialog.close();
    }
    
    //自动补全机场信息
    vst_pet_util.commListSuggest($("#startAirportString"),$("#startAirport"),'/vst_admin/prod/traffic/searchAirportList.do','');
    vst_pet_util.commListSuggest($("#arriveAirportString"),$("#arriveAirport"),'/vst_admin/prod/traffic/searchAirportList.do','');
    vst_pet_util.commListSuggest($("#airlineString"),$("#airline"),'/vst_admin/biz/flight/searchAirlineList.do','');
    vst_pet_util.commListSuggest($("#airplaneString"),$("#airplane"),'/vst_admin/biz/flight/searchAirplanetypeList.do','');
    
    //保存
    $("#saveButton").on("click",function(){
        if(!$("#dataForm").validate().form()){
            return false;
        }
        
        var startTerminal = $("#startTerminal").val();
        var arriveTerminal = $("#arriveTerminal").val();
        if(startTerminal.length > 20){
           $.alert("始发机场航站楼不能超过20个字符。");
           return;
        }
        if(arriveTerminal.length > 20){
           $.alert("到达机场航站楼不能超过20个字符。");
           return;
        }

        var arriveTime = $("input[name='arriveTime']").val();
        var startTime = $("input[name='startTime']").val();

        if(startTime==null || startTime==""){
            var errorhtml = '<i for="airlineString" class="error">请输入正确的起飞时间</i>';
            if($("input[name='startTime']").siblings("i").size()<1){
                $("input[name='startTime']").after(errorhtml);
            }
            return;
        }
        if(arriveTime==null || arriveTime==""){
            var errorhtml = '<i for="airlineString" class="error">请输入正确的降落时间</i>';
            if($("input[name='arriveTime']").siblings("i").size()<1){
                $("input[name='arriveTime']").after(errorhtml);
            }
            return;
        }

        var errorhtml = '<i for="airlineString" class="error">请输入正确的航空公司</i>';
		if($("#airline").val() == "" && $("#airlineString").val()!= ""){
		if($("#airlineString").siblings("i").size()<1){
			$("#airlineString").after(errorhtml);
		}
		return;
		}
		var startAirportErrorhtml = '<i for="startAirportString" class="error">请输入正确的始发机场</i>';
		if($("#startAirport").val() == "" && $("#startAirportString").val()!= ""){
		if($("#startAirportString").siblings("i").size()<1){
			$("#startAirportString").after(startAirportErrorhtml);
		}
		return;
		}
		var arriveAirportErrorhtml = '<i for="arriveAirportString" class="error">请输入正确的到达机场</i>';
		if($("#arriveAirport").val() == "" && $("#arriveAirportString").val()!= ""){
		if($("#arriveAirportString").siblings("i").size()<1){
			$("#arriveAirportString").after(arriveAirportErrorhtml);
		}
		return;
		}
        
        if (confirm('确定修改吗？')) {
            $.ajax({
                url : "/vst_admin/biz/flight/updateFlight.do",
                type : "post",
                dataType:"json",
                async: false,
                data : $("#dataForm").serialize(),
                success : function(result) {
                   if(result.code=="success"){
                        alert(result.message);
                        updateDialog.close();
                        window.location.reload();
                    }else {
                        alert(result.message);
                    }
                }
            }); 
        }             
    });
});

    
</script>
</body>
</html>
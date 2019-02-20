
<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body >
<div class="iframe_search" style="height:850px;width:1000px">
    <form method="post"   id="dataForm">
        <input type="hidden" id="hotPlaceId" name="hotPlaceId" value="${hotPlaceId }"/>
        <input type="hidden" id="destName" name="destName" <#if (hotPlaceInfo?? && hotPlaceInfo.destName??)>value="${hotPlaceInfo.destName}"</#if>>
        <input type="hidden" id="destType" name="destType" <#if (hotPlaceInfo?? && hotPlaceInfo.destType??)>value="${hotPlaceInfo.destType}"</#if>>
        <input type="hidden" id="districtName" name="districtName" <#if (hotPlaceInfo?? && hotPlaceInfo.districtName??)>value="${hotPlaceInfo.districtName}"</#if>>
        <input type="hidden" id="cancleFlag" name="cancleFlag" <#if (hotPlaceInfo?? && hotPlaceInfo.cancleFlag??)>value="${hotPlaceInfo.cancleFlag}"</#if>>
        <input type="hidden" id="destId" name="destId" value="">
        <input type="hidden" id="longitude" name="longitude" value="">
        <input type="hidden" id="latitude" name="latitude" value="">
        <input type="hidden" id="cityDistrictId" name="cityDistrictId" value="">
        <table class="s_table">
            <tr>
                <td class="e_label"><i class="cc1">*</i>目的地：</td>
                <td>
                    <span id="destNameSpan"><#if (hotPlaceInfo?? && hotPlaceInfo.destName??)>${hotPlaceInfo.destName}</#if></span>
                    <#if !hotPlaceId??><a id="chooseDest">选择</a></#if>
                </td>
            </tr>
            <tr>
                <td class="e_label"><i class="cc1">*</i>目的地类型：</td>
                <td>
                    <span id="destTypeSpan"><#if (hotPlaceInfo?? && hotPlaceInfo.destType??)>${hotPlaceInfo.destType}</#if></span>
                </td>
            </tr>
            <tr>
                <td class="e_label"><i class="cc1">*</i>行政区：</td>
                <td>
                    <span id="districtNameSpan"><#if (hotPlaceInfo?? && hotPlaceInfo.districtName??)>${hotPlaceInfo.districtName}</#if></span>
                </td>
            </tr>
            <tr>
                <td class="e_label"><i class="cc1">*</i>状态：</td>
                <td>
                    <span id="cancleFlagSpan">
                        <#if (hotPlaceInfo?? && hotPlaceInfo.cancleFlag=="Y")>有效</#if>
                        <#if (hotPlaceInfo?? && hotPlaceInfo.cancleFlag=="N")>无效</#if>
                    </span>
                </td>
            </tr>
            <tr>
                <td class="e_label"><i class="cc1">*</i>热度：</td>
                <td>
                    <input type="text" class="w35" name="hotNum" id="hotNum" maxlength="11" <#if (hotPlaceInfo?? && hotPlaceInfo.hotNum??)>value="${hotPlaceInfo.hotNum}"</#if> >
                </td>
            </tr>
            <tr>
                <td class="e_label"><i class="cc1">*</i>别名：</td>
                <td>
                    <input type="text" class="w35" name="hotPlaceAlias" id="hotPlaceAlias" id="" maxlength="11" <#if (hotPlaceInfo?? && hotPlaceInfo.hotPlaceAlias??)>value="${hotPlaceInfo.hotPlaceAlias}"</#if> >
                </td>
            </tr>
            <tr>
                <td  ><a class="btn btn_cc1" id="save">保存</a> </td>
                <td  ><a class="btn btn_cc1" id="reset">取消</a> </td>
            </tr>

        </table>
    </form>
</div>
<#include "/base/foot.ftl"/>
</body>

</html>
<script>

    //保存
    $("#save").click(function(){
        var hotPlaceId = $("#hotPlaceId").val();
        if(hotPlaceId == null || hotPlaceId == '') {
            var destName = $("#destName").val();
            if(destName == null || destName == '') {
                alert("目的地不能为空");
                return false;
            }
        }
        var hotNum = $("#hotNum").val();
        if(hotNum == null || hotNum == '' || hotNum <= 0) {
            alert("热度不能为空且不能小于1");
            return false;
        }
        // var loading = top.pandora.loading("正在努力保存中...");
        $.ajax({
            url : "/vst_admin/superfreetour/hotPlaceManage/saveHotPlaceInfo.do",
            type : "post",
            dataType : 'json',
            data :  $("#dataForm").serialize(),
            success : function(result) {
                if (result.code == "error") {
                    alert("未查询到该目的地的经纬度，保存失败！");
                }else{
                    // loading.close();
                    parent.confirmAndRefresh(result);
                    parent.docEditDialog.close();
                }
            }
            ,
            error : function(){
                // loading.close();
            }
        });

    });

    //取消
    $("#reset").click(function(){
        parent.docEditDialog.close();
    });

    //选择目的地
    var chooseDestDialog;
    $("#chooseDest").click(function(){
        chooseDestDialog = new xDialog("/vst_admin/superfreetour/hotPlaceManage/chooseDestPage.do",{}, {title:"选择目的地",width:1000,zIndex:200});
    });

    function onSelectDest(params){
        if(params!=null){
            if(params.destName==""){
                $("#destNameSpan").html("");
                $("#destName").val("");
                $("#destTypeSpan").html("");
                $("#destType").val("");
                $("#cancleFlagSpan").html("");
                $("#cancleFlag").val("");
                $("#districtId").val("");
                $("#districtNameSpan").html("");
                $("#districtName").val("");
                chooseDestDialog.close();
            }else{ //设置属性
                if (params.destId != null && params.destId != "") {
                    $.ajax({
                        url : "/vst_admin/superfreetour/hotPlaceManage/checkHotplaceExist.do",
                        type : "get",
                        dataType : 'json',
                        data :  {
                            destId : params.destId,
                            destType : params.destTypeCode
                        },
                        success : function(result) {
                            if (result.code == "success") {
                                $("#destNameSpan").html(params.destName);
                                $("#destName").val(params.destName);
                                $("#destTypeSpan").html(params.destType);
                                $("#destType").val(params.destTypeCode);
                                $("#cancleFlagSpan").html("有效");
                                $("#cancleFlag").val("Y");
                                $("#destId").val(params.destId);
                                //设置行政区
                                districtName(params.districtId);
                                chooseDestDialog.close();
                            }else {
                                alert("目的地【"+params.destName+"】已经被添加到热门目的地请重新选择!");
                            }
                        }
                        ,
                        error : function(){
                            // loading.close();
                        }
                    });
                }

            }
        }

    }

    function onSelectbizDist(params){
        if(params!=null){
            if(params.signName==""){
                $("#destNameSpan").html("");
                $("#destName").val("");
                $("#destTypeSpan").html("");
                $("#destType").val("");
                $("#cancleFlagSpan").html("");
                $("#cancleFlag").val("");
                $("#districtId").val("");
                $("#districtNameSpan").html("");
                $("#districtName").val("");
                $("#longitude").val("");
                $("#latitude").val("");
                chooseDestDialog.close();
            }else{ //设置属性
                if (params.signId != null && params.signId != "") {
                    $.ajax({
                        url : "/vst_admin/superfreetour/hotPlaceManage/checkHotplaceExist.do",
                        type : "get",
                        dataType : 'json',
                        data :  {
                            destId : params.signId,
                            destType : params.signType
                        },
                        success : function(result) {
                            if (result.code == "success") {
                                $("#destNameSpan").html(params.signName);
                                $("#destName").val(params.signName);
                                $("#destTypeSpan").html(params.signTypeCnName);
                                $("#destType").val(params.signType);
                                $("#longitude").val(params.longitude);
                                $("#latitude").val(params.latitude);
                                $("#destId").val(params.signId);
                                if (params.cancelFlag =="Y") {
                                    $("#cancleFlagSpan").html("有效");
                                    $("#cancleFlag").val("Y");
                                }else {
                                    $("#cancleFlagSpan").html("无效");
                                    $("#cancleFlag").val("N");
                                }
                                $("#districtId").val(params.districtId);
                                //设置行政区
                                districtName(params.districtId);
                                chooseDestDialog.close();
                            }else {
                                alert("目的地【"+params.signName+"】已经被添加到热门目的地请重新选择!");
                            }
                        }
                        ,
                        error : function(){
                            // loading.close();
                        }
                    });
                }
            }
        }
    }


    function districtName(districtId) {
        $.ajax({
            url : "/vst_admin/superfreetour/hotPlaceManage/selectParentsDistrictOfParams.do",
            type : "post",
            dataType : 'json',
            data :  {districtId:districtId},
            success : function(result) {
                $("#districtNameSpan").html(result.attributes.districtName);
                $("#districtName").val(result.attributes.districtName);
                $("#cityDistrictId").val(result.attributes.cityDistrictId);
            }
            ,
            error : function(){
                alert("获取行政区失败");
            }
        });
    }



</script>
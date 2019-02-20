<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <#include "/base/head_meta.ftl"/>
    <!--新增样式表-->
    <link rel="stylesheet" href="/vst_admin/css/line-prd.css"/>
</head>
<body> 
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">线路</a>：</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">交通信息维护</li>
    </ul>
</div>
<div class="iframe_content mt10">
    <div class="tiptext tip-warning"><span class="tip-icon tip-icon-warning"></span>友情提示：</div>
    <div class="p_box box_info p_line">
        <div class="box_content JS_line_prd">
            <table class="e_table form-inline">
                <tbody>
            	<form action="/vst_admin/prod/traffic/updateProdTraffic.do" method="post" id="dataForm">
				<input type="hidden" id="productId" name="productId" value="${productId!''}">
				<input type="hidden" id="trafficId" name="trafficId" value="<#if prodTraffic??>${prodTraffic.trafficId!''}</#if>">
				<input type="hidden" id="toTypeCode" name="toTypeCode"  value="<#if prodTraffic??>${prodTraffic.toType!''}</#if>"/>
				<input type="hidden" id="toBackCode" name="toBackCode" value="<#if prodTraffic??>${prodTraffic.backType!''}</#if>"/>
                <input type="hidden" id="addFlag" name="addFlag" value="${addFlag!''}"/>
                <tr>
                    <td class="e_label" width="150"><i class="cc1">*</i>去程交通：</td>
                    <td>
                        <select id="toType" name="toType" class="JS_select_go">
                            <option value="">无</option>
                            <#list trafficTypeList as list>
		                      <option value=${list.code!''} <#if prodTraffic?? && prodTraffic.toType==list.code>selected=selected</#if> >${list.cnName!''}</option>
                        	</#list>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="e_label" width="150"><i class="cc1">*</i>返程交通：</td>
                    <td>
                        <select id="backType" name="backType" class="JS_select_return">
                            <option value="">无</option>
                            <#list trafficTypeList as list>
		                    	<option value=${list.code!''}  <#if prodTraffic?? && prodTraffic.backType==list.code>selected=selected</#if>  >${list.cnName!''}</option>
                        	</#list>
                        </select>
                    </td>
                </tr>
                <tr <#if prodTraffic==null || (prodTraffic?? && prodTraffic.toType!='BUS') >style="display:none"</#if> id="cheseFlag2">
					<td class="e_label"><i class="cc1">*</i>巴士去程上车点是否下单可选：</td>
					<td>
						<input type="radio" name="cheseFlag2" value="Y" checked=checeked  <#if prodTraffic?? && prodTraffic.cheseFlag2=='Y'>checked=checeked</#if> >是
						<input type="radio" name="cheseFlag2" value="N"  <#if prodTraffic?? && prodTraffic.cheseFlag2=='N'>checked=checeked</#if> >否
						<i class="cc1">（注，下单可选，则用户下单可选上车点，并自动填充到订单备注）</i>
                    </td>
                </tr>
                <tr>
                    <td class="e_label" width="150"><i class="cc1">*</i>是否是参考信息：</td>
                    <td>
                        <label>
                        	<input class="lp-radio" type="radio" name="referFlag" value="Y" checked=checeked <#if prodTraffic?? && prodTraffic.referFlag == 'Y'>checked=checeked</#if> >是
                        </label>
                        <label>
                        	<input class="lp-radio" type="radio" name="referFlag" value="N" <#if prodTraffic?? && prodTraffic.referFlag == 'N'>checked=checeked</#if> >否
                        </label>
                        <span class="lp-red">（注，参考信息，则前台会有对应的说明）</span>
                    </td>
                </tr>
                </form>
                <tr>
                    <td class="e_label" width="150">
                        <div class="fr operate"><a class="btn btn_cc1 JS_btn_save" id="save_button">保存</a></div>
                    </td>
                    <td>
                        <span class="lp-red fl"></span>

                        <div class="fl operate">
                            <a class="btn btn_cc1" href="/vst_admin/biz/flight/findFlightList.do" target="_blank">维护航班</a>
                            <a class="btn btn_cc1" href="/vst_admin/biz/train/findTrainList.do" target="_blank">维护火车</a>
                        </div>
                    </td>
                </tr>
                <#if prodTraffic??>
                <tr>
                    <td class="e_label" width="150">
                        <div class="fr operate"> <a class="btn btn_cc1 JS_btn_add">添加交通信息</a></div>
                    </td>
                    <td>
                    </td>
                </tr>
                </#if>
                <tr>
                    <td colspan="2">

                        <!--交通信息 开始-->
                        <div class="lp-traffics JS_traffics">

                            <!--选项卡-->
                            <div class="lp-head">
                                <div class="lp-tabs-box">
                                    <div class="lp-tabs clearfix"></div>
                                </div>
                                <div class="lp-left"></div>
                                <div class="lp-right"></div>
                            </div>

                            <!--选项卡内容-->
                            <div class="lp-body"></div>
                        </div>
                        <!--交通信息 结束-->

                    </td>
                </tr>
                <tr class="save_traffic_detail_tr">
                    <td class="e_label" width="150">
                        <div class="fr operate"> <a class="btn btn_cc1" id="save_traffic_detail">保存交通信息</a></div>
                    </td>
                    <td>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 保存交通详细信息FORM-->
<form id="trafficDetailForm"></form>

<!--引入交通信息 模板-->
<#include "/prod/packageTour/traffic/prodTrafficTemplate.ftl"/>
<!--引入页脚信息-->
<#include "/base/foot.ftl"/>
<!--引入underscore.js脚本-->
<script type="text/javascript" src="/vst_admin/js/underscore-min.js"></script>
<script type="text/javascript">
var districtSelectDialog;
<#---选择城市列表（单选）--->
function onSelectDistrict(params){

	if(params!=null){
		var cityInput =$("input[data-tag="+params.uniqueTag+"]");
		//获取存储cityID的隐藏域input
		var cityIdInput = cityInput.next()
		if (cityInput.length == 0 || cityIdInput.length ==0) {
			$.alert("选择城市信息时出错");
			return;
		}
		cityInput.val(params.districtName);
		cityIdInput.val(params.districtId);
	}

	districtSelectDialog.close();
	$("#districtError").hide();

    var productType=$("#productType",window.parent.document).val();
    if(productType!="FOREIGNLINE"){
        $(".line_route_select").attr("style","display:none");
    }
}
</script>
<!--vst供应商打包产品交通信息结构化JS脚本文件-->
<script src="/vst_admin/js/line-prd.js"></script>

</body>
</html>
<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">产品管理</a> &gt;</li>
            <li class="active">低毛利产品</li>
        </ul>
</div>

<div class="iframe_content">

    <div class="p_box box_info">
        <form method="post" action='/vst_admin/goods/grossMargin/showSuppGoodsGrossMarginProdLogsList.do' id="searchForm">
            <table class="s_table">
                <tbody>
                <tr>
                    <td class="s_label">产品ID：</td>
                    <td class="w18">
                        <input type="text" name="productId" value="${productId}" number="true">
                    </td>
                    <td class="s_label">产品名称：</td>
                    <td class="w18">
                        <input type="text" name="productName" value="${productName}">
                    </td>
                    <td class="s_label">时间：</td>
                    <td class="w38">
                        <input type="text" value="${startDate}" name="startDate" errorEle="selectDate" class="Wdate" id="d4321" onFocus="WdatePicker({readOnly:true,maxDate:'#F{$dp.$D(\'d4322\',{d:0});}'})" />
                        --
                        <input type="text" value="${endDate}" name="endDate" errorEle="selectDate" class="Wdate" id="d4322" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4321\',{y:2});}',readOnly:true})" />
                    </td>
                </tr>
                <tr>
                    <td class="s_label">商品ID：</td>
                    <td class="w18">
                        <input type="text" name="goodsId" value="${goodsId}" number="true">
                    </td>
                    <td class="s_label">商品名称：</td>
                    <td class="w18">
                        <input type="text" name="goodsName" value="${goodsName}">
                    </td>
                    <td class="s_label">操作人：</td>
                    <td class="w18">
                        <input type="text" name="operator" id="operator" value="${operator!''}">
                        <input type="hidden" name="creatorId" id="creatorId" value="${creatorId!''}">
                    </td>
                </tr>
                <tr>
                    <td class="s_label">所属BU：</td>
                    <td class="w18">
                        <select name="bu" >
                            <option value="">全部</option>
                        <#list buList as list>
                            <option value=${list.code!''} <#if list.code==bu>selected="selected"</#if> >${list.cnName!''}</option>
                        </#list>
                        </select>
                    </td>
                    <td class="s_label">所属分公司：</td>
                    <td class="w18">
                        <select name="filiale" >
                            <option value="">全部</option>
                        <#list filialeList as list>
                            <option value=${list.code!''} <#if list.code==filiale>selected="selected"</#if>  >${list.cnName!''}</option>
                        </#list>
                        </select>
                    </td>
                    <td class=" operate mt10">
                        <a class="btn btn_cc1" id="search_button">查询</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
    <!-- 主要内容显示区域\\ -->
<#if pageParam??>
	<#if pageParam.items?? &&  pageParam.items?size &gt; 0>
        <div class="p_box box_info">
            <table class="p_table table_center">
                <thead>
                <tr>
                    <th width="80px">品类</th>
                    <th>产品Id</th>
                    <th>产品名称</th>
                    <th>产品状态</th>
                    <th>是否可售</th>
                    <th>审核状态</th>
                    <th width="350px">操作</th>
                </tr>
                </thead>
                <tbody>
					<#list pageParam.items as prod>
                    <tr >
                        <td>${prod.bizCategory.categoryName!''} </td>
                        <td>${prod.productId}</td>
                        <td>${prod.productName!''} </td>
                        <td>
                            <#if prod.cancelFlag == "Y">
                                <span style="color:green" class="cancelProd">有效</span>
                            <#else>
                                <span style="color:red" class="cancelProd">无效</span>
                            </#if>
                        </td>
                        <td>
                            <#if prod.saleFlag =="Y">是<#else>否</#if>
                        </td>
                        <td>
                            <#if prod.auditStatus??>
                                <#list auditTypeList as audit>
                                    <#if prod?? && prod.auditStatus==audit.code>${audit.cnName}</#if>
                                </#list>
                            </#if>
                        </td>
                        <td class="oper">
                            <a href="javascript:void(0);" class="viewDetail" data="${prod.productId!''}"  >查看详情</a>
                        </td>
                    </tr>
					</#list>
                </tbody>
            </table>
			<#if pageParam.items?exists>
                <div class="paging" >
				${pageParam.getPagination()}
                </div>
			</#if>

        </div><!-- div p_box -->
	<#else>
        <div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
	</#if>
</#if>
    <div id="showProductTargetBox"  style="display:none;padding:10px; border:1px solid #FF8801; background-color:#FFFFE0;overflow:auto;max-height:200px;">
    </div>
    <!-- //主要内容显示区域 -->
</div>

<#include "/base/foot.ftl"/>
</body>
</html>

<script>
    vst_pet_util.superUserSuggest("#operator","#creatorId");
</script>
<script>

	var goodsGrossMarginAddDialog,goodsGrossMarginUpdateDialog;
    var destSelectDialog;
    //选择

    //查询
    $("#search_button").bind("click",function(){
        if(!$("#searchForm").validate().form()){
            return false;
        }
        $("#searchForm").submit();
    });

    //新建
    $(".viewDetail").click(function(){
        //打开弹出窗口
        var productId = $(this).attr("data");
        new xDialog("/vst_admin/goods/grossMargin/showSuppGoodsGrossMarginGoodsLogsList.do?productId="+productId,{},{title:"查看毛利率详情",width:900,iframe:true});
    });

</script>
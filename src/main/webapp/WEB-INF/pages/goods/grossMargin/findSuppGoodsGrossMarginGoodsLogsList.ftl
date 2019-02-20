<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">产品管理</a> &gt;</li>
            <li class="active"> 低毛利商品列表</li>
        </ul>
</div>

<div class="iframe_content">
    <!-- 主要内容显示区域\\ -->
<#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
        <div class="p_box box_info">
            <table class="p_table table_center">
                <thead>
                <tr>
                    <th width="80px">商品ID</th>
                    <th>商品名称</th>
                    <th>所属BU</th>
                    <th>分公司</th>
                    <th>销售价</th>
                    <th>结算价</th>
                    <th>毛利点/金额</th>
                    <th>时间</th>
                    <th>毛利基准</th>
                    <th>上架人员</th>
                    <th>上架原因</th>
                    <th>上架时间</th>
                </tr>
                </thead>
                <tbody>
					<#list pageParam.items as gross>
                    <tr >
                        <td>${gross.suppGoodsId!''} </td>
                        <td>${gross.suppGoods.goodsName!''} </td>
                        <td>${gross.suppGoods.bu!''} </td>
                        <td>${gross.suppGoods.filiale!''} </td>
                        <td><#if gross.price??>${(gross.price/100)?string('0.00')}</#if></td>
                        <td><#if gross.settlementPrice??>${(gross.settlementPrice/100)?string('0.00')}</#if> </td>
                        <td><#if gross.grossMarginPointLong??> ${(gross.grossMarginPointLong/100)?string('0.00')}</#if> ${gross.grossMarginPointUnit}</td>
                        <td>${gross.specDate?string("yyyy-MM-dd")} </td>
                        <td><#if gross.grossMarginLong??>${(gross.grossMarginLong/100)?string('0.00')}</#if> ${gross.grossMarginUnit}</td>
                        <td>${gross.creatorName!''} </td>
                        <td>${gross.reason!''} </td>
                        <td>${gross.createDate?string("yyyy-MM-dd HH:mm:ss")} </td>

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
        $("#searchForm").submit();
    });

    function confirmAndRefresh(result){
        if (result.code == "success") {
            pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
                $("#searchForm").submit();
            }});
        }else {
            pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
                $.alert(result.message);
            }});
        }
    };

    $("a.editProd").click(function (){
        var suppGoodsGrossMarginId = $(this).attr("data");
        goodsGrossMarginUpdateDialog = new xDialog("/vst_admin/goods/grossMargin/showUpdateSuppGoodsGrossMargin.do",{suppGoodsGrossMarginId:suppGoodsGrossMarginId},{title:"修改毛利率",width:900,height:700});
    });

    $("a.delete").click(function (){
        var suppGoodsGrossMarginId = $(this).attr("data");
        $.confirm("是否删除?",function(){
            $.ajax({
                url : "/vst_admin/goods/grossMargin/deleteSuppGoodsGrossMargin.do",
                type : "post",
                data : {"id":suppGoodsGrossMarginId},
                success : function(result) {
                    confirmAndRefresh(result);
                },
                error : function(){
                }
            })

        });
    });


    //新建
    $("#new_button").bind("click",function(){
        //打开弹出窗口
        goodsGrossMarginAddDialog = new xDialog("/vst_admin/goods/grossMargin/showAddSuppGoodsGrossMargin.do",{},{title:"设置毛利率",width:900,height:700});
        return;
    });

</script>
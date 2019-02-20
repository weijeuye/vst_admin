<!DOCTYPE html>
<html>
<head>
    <#include "/base/head_meta.ftl"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css">
    <style>
        .btn.btn-primary {
            color: #fff;
            background: #4d90fe;
            border: 1px solid #2979fe;
        }

        .proTit {
            display: inline-block;
            max-width: 251px;
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">金融</a> &gt;</li>
        <li><a href="#">商品维护</a> &gt;</li>
        <li class="active">供应商合同关联</li>
    </ul>
</div>
<div class="iframe_content mt10">
    <form method="post" action="/vst_admin/finance/goods/findSuppGoodsList.do" id="searchForm">
        <input type="hidden" name="prodProduct.bizCategory.categoryName"
               value="${suppGoods.prodProduct.bizCategory.categoryName!''}">
        <input type="hidden" name="prodProduct.productId" value="${suppGoods.prodProduct.productId!''}">
        <input type="hidden" id="categoryId" name="prodProduct.bizCategory.categoryId"
               value="${suppGoods.prodProduct.bizCategory.categoryId!''}">
        <input type="hidden" id="productBranchId" name="productBranchId"
               value="${prodProductBranch.productBranchId!''}">

        <table class="e_table form-inline">
            <tbody>
            <tr>
                <td width="150" class="e_label td_top"><i class="cc1">*</i>选择供应商：</td>
                <td class="w18" colspan="5">
                    <input type="hidden" name="productId" value="${suppGoods.prodProduct.productId!''}">
                    <input type="text" placeholder="请输入供应商名称" class="w350 search searchInput"
                           name="suppSupplier.supplierName" id="supplierName"
                           <#if suppGoods != null && suppGoods.suppSupplier != null>value="${suppGoods.suppSupplier.supplierName}"</#if>>
                    <input type="hidden" name="supplierId" id="supplierId" value="${suppGoods.supplierId!''}"
                           required="true">

                    <a class="btn btn_cc1" id="search_button">查询供应商商品</a>
                    <div class="cc3"> 注：下面的内容维护人员、商品默认合同，添加新商品时均为默认值。</div>
                </td>
            </tr>
            <tr>
                <td class="e_label td_top">内容维护人员：</td>
                <td class="w18" colspan="5">
                    <input type="text" name="contentManagerName" id="contentManagerName" class="w350 search searchInput"
                           placeholder="请输入维护人员名称"
                           <#if suppGoods!=null>value="${suppGoods.contentManagerName!''}"</#if> >
                    <input type="hidden" name="contentManagerId" id="contentManagerId"
                           <#if suppGoods!=null>value="${suppGoods.contentManagerId!''}"</#if>>
                    <div class="cc3"> 注：后续会对其内容质量进行考核。</div>
                </td>
            </tr>
            <tr>
                <td class="e_label td_top">商品默认合同：</td>
                <td class="w18" colspan="5">
                    <label id="contractName"
                           name="contractName"><#if suppGoods!=null && suppGoods.suppContract != null>${suppGoods.suppContract.contractName!''}</#if></label>
                    <input type="hidden" id="contractId" name="contractId"
                           <#if suppGoods!=null && suppGoods.suppContract != null>value="${suppGoods.suppContract.contractId!''}"</#if>>
                    <a id="change_button" href="javascript:void(0);">[更改]</a>
                </td>
            </tr>
            <tr>
                <td class="e_label"><span class="notnull">*</span>有/无效：</td>
                <td>
                    <select id="cancelFlagBtn" name="cancelFlag">
                        <option value="All" <#if suppGoods.cancelFlag == "ALL">selected</#if>>全部</option>
                        <option value="Y" <#if suppGoods.cancelFlag == "Y">selected</#if>>是</option>
                        <option value="N" <#if suppGoods.cancelFlag == "N">selected</#if>>否</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="e_label"></td>
                <td>
                    <div class="fl operate"><a class="btn btn_cc1" id="new_button" name="new_button">添加新商品</a></div>
                </td>
            </tr>
            </tbody>
        </table>
    </form>

    <div class="p_box box_info p_line">
        <div class="title">
            <h2 class="f16">金融商品</h2>
        </div>
        <table class="p_table table_center mt10">
            <colgroup>
                <col>
                <col>
                <col>
                <col>
                <col class="w500">
            </colgroup>
            <thead>
            <tr>
                <th>商品名称</th>
                <th>商品编号</th>
                <th>是否有效</th>
                <th>产品维护人员</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <#if suppGoodsList?? && suppGoodsList?size &gt; 0>
                <#list suppGoodsList as suppGoods>
                    <tr>
                        <td>
                            <div class="proTit">${suppGoods.goodsName!''}</div>
                        </td>
                        <td>${suppGoods.suppGoodsId!''}</td>
                        <td>
                            <#if suppGoods.cancelFlag == "Y">
                                <span style="color:green" class="cancelProp">有效</span>
                            <#else>
							    <span style="color:red" class="cancelProp">无效</span>
                            </#if>
                        </td>
                        <td>${suppGoods.contentManagerName!''}</td>
                        <td>
                            <a href="javascript:void(0);" class="product-link editProp"
                               data="${suppGoods.suppGoodsId!''}">商品基础信息</a>
                            <a href="javascript:void(0);" class="product-link right"
                               data="${suppGoods.suppGoodsId!''}">商品权益</a>
                            <a href="javascript:void(0);" class="product-link desc"
                               data="${suppGoods.suppGoodsId!''}">商品描述</a>
                            <a href="javascript:void(0);" class="product-link orderRequire"
                               data="${suppGoods.suppGoodsId!''}"
                               <#if showOrderRequire != 'Y'>style="pointer-events: none;color: grey"</#if>>下单必填项</a>
                            <#if suppGoods.cancelFlag == "Y">
                                <a href="javascript:void(0);" class="product-link cancelProp"
                                   data="N" suppGoodsId="${suppGoods.suppGoodsId!''}">设为无效</a>
                            <#else>
                                <a href="javascript:void(0);" class="product-link cancelProp"
                                   data="Y" suppGoodsId="${suppGoods.suppGoodsId!''}">设为有效</a>
                            </#if>
                            <a href="javascript:void(0);" class="product-link up" <#if suppGoods_index=0>
                               style="display:none"</#if>>向上</a>
                            <a href="javascript:void(0);" class="product-link down"
                               <#if suppGoods_index=suppGoodsList?size-1> style="display:none"</#if>>向下</a>
                            <a href="javascript:void(0);" class="product-link showLogDialog"
                               param='objectId=${suppGoods.suppGoodsId}&objectType=SUPP_GOODS_GOODS&sysName=VST'>操作日志</a>
                            <a href="javascript:void(0);" class="product-link copyGoods"
                               data="${suppGoods.suppGoodsId!''}">复制商品</a>
                        </td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan=10>
                        <div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
                    </td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>
</div>
<#include "/base/foot.ftl"/>
<!--新增脚本文件-->
<script src="http://pic.lvmama.com/js/backstage/vst-product-provision.js"></script>
</body>
</html>
<script>
    vst_pet_util.superUserSuggest("#contentManagerName", "input[name=contentManagerId]");
    vst_pet_util.commListSuggest("#supplierName", "#supplierId", '/vst_back/supp/supplier/searchSupplierList.do', '${suppJsonList}');
</script>
<script>
    var selectContractDialog;

    //供应商合同回调函数
    function onSelectContract(params) {
        if (params != null) {
            $("#contractName").text(params.contractName);
            $("#contractId").val(params.contractId);
        }
        selectContractDialog.close();
    }

    //打开选择供应商合同列表
    $("#change_button").click(function () {
        if ($("#supplierId").val() != null && $("#supplierId").val() != "") {
            selectContractDialog = new xDialog("/vst_back/supp/suppContract/selectContractListBySupplier.do?supplierId=" + $("#supplierId").val(), {}, {
                title: "选择供应商合同",
                width: "600"
            });
        } else {
            $.alert("请先选择供应商！");
        }
    });

    function querySuppGoods() {
        if ($("#supplierId").val() != null && $("#supplierId").val() != "") {
            $("#searchForm").submit();
        } else {
            $.alert("请先选择供应商！");
        }
    }

    $('#cancelFlagBtn').change(querySuppGoods);
    //查询
    $("#search_button").bind("click", querySuppGoods);
    //新建商品
    $("a[name=new_button]").bind("click", function () {
        if ($("#supplierId").val() != null && $("#supplierId").val() != "") {
            new xDialog("/vst_admin/finance/goods/showAddSuppGoods.do", {
                productId: $("input[name='prodProduct.productId']").val(),
                supplierId: $("#supplierId").val(),
                contractName: $("#contractName").val(),
                contractId: $("#contractId").val(),
                contentManagerId: $("#contentManagerId").val(),
                contentManagerName: $("#contentManagerName").val(),
                categoryId: $("#categoryId").val(),
                productBranchId: $("#productBranchId").val()
            }, {title: "新增商品", width: 900});
        } else {
            $.alert("请先选择供应商！");
        }
    });
    //编辑商品
    $(".editProp").bind("click", function () {
        var suppGoodsId = $(this).attr("data");
        var productBranchId = $("#productBranchId").val();
        new xDialog("/vst_admin/finance/goods/showUpdateSuppGoods.do", {
            productBranchId: productBranchId,
            suppGoodsId: suppGoodsId,
            productId: $("input[name='prodProduct.productId']").val(),
            supplierId: $("#supplierId").val(),
            contractId: $("#contractId").val(),
            contentManagerId: $("#contentManagerId").val(),
            categoryId: $("#categoryId").val()
        }, {title: "编辑商品", width: 900});
    });
    //设置为有效或无效
    $(".cancelProp").bind("click", function () {
        var entity = $(this);
        var cancelFlag = entity.attr("data");
        var suppGoodsId = entity.attr("suppGoodsId");
        var productId = $("input[name='productId']").val();
        $.ajax({
            url: "/vst_admin/finance/goods/cancelGoods.do",
            type: "post",
            dataType: "JSON",
            data: {cancelFlag: cancelFlag, suppGoodsId: suppGoodsId, productId: productId},
            success: function (result) {
                if (result.code == "success") {
                    $.alert(result.message, function () {
                        if (cancelFlag == 'N') {
                            entity.attr("data", "Y");
                            entity.text("设为有效");
                            $("span.cancelProp", entity.parents("tr")).css("color", "red").text("无效");
                        } else if (cancelFlag == 'Y') {
                            entity.attr("data", "N");
                            entity.text("设为无效");
                            $("span.cancelProp", entity.parents("tr")).css("color", "green").text("有效");
                        }
                    });
                } else {
                    $.alert(result.message);
                }
            }
        });
    });

    $(".up").click(function () {
        var trLength = $(".down").length;
        var $tr = $(this).closest("tr");
        if ($tr.index() != 0) {
            var a = $tr.find("td").eq(1).text();
            var b = $tr.prev().find("td").eq(1).text();
            if (updateSeq(a, b)) {
                $tr.prev().before($tr);
                if (trLength == 2) {
                    //如果只有2条数据
                    $tr.next().find("td:last").find(".up").show();
                    $tr.next().find("td:last").find(".down").hide();
                    $tr.find("td:last").find(".down").show();
                    $tr.find("td:last").find(".up").hide();
                } else {
                    if ($tr.index() == 0) {
                        $tr.next().find("td:last").find(".up").show();
                        $tr.find("td:last").find(".up").hide();
                    } else if ($tr.index() == trLength - 2) {
                        $tr.next().find("td:last").find(".down").hide();
                        $tr.find("td:last").find(".down").show();
                    }
                }
            }
        }
    });

    $(".down").click(function () {
        var trLength = $(".down").length;
        var $tr = $(this).parents("tr");
        if ($tr.index() != trLength - 1) {
            var a = $tr.find("td").eq(1).text();
            var b = $tr.next().find("td").eq(1).text();
            if (updateSeq(a, b)) {
                $tr.next().after($tr);
                if (trLength == 2) {
                    //如果只有2条数据
                    $tr.prev().find("td:last").find(".down").show();
                    $tr.prev().find("td:last").find(".up").hide();
                    $tr.find("td:last").find(".up").show();
                    $tr.find("td:last").find(".down").hide();
                } else {
                    if ($tr.index() == 1) {
                        $tr.prev().find("td:last").find(".up").hide();
                        $tr.find("td:last").find(".up").show();
                    } else if ($tr.index() == trLength - 1) {
                        $tr.prev().find("td:last").find(".down").show();
                        $tr.find("td:last").find(".down").hide();
                    }
                }
            }
        }
    });

    function updateSeq(a, b) {
        var result = true;
        $.ajax({
            url: "/vst_admin/finance/goods/updateSeq.do",
            type: "post",
            dataType: "JSON",
            data: {"goodsIdA": a, "goodsIdB": b},
            success: function (result) {
                if (result.code == "success") {
                } else {
                    result = false;
                    $.alert(result.message);
                }
            }
        });
        return result;
    }

    var descDialog;
    var orderRequierd;

    //商品权益
    $(".right").bind("click", function () {
        var suppGoodsId = $(this).attr("data");
        var productId = $("input[name='productId']").val();
        descDialog = new xDialog("/vst_admin/finance/interestsBonus/showInterestsBonusMain.do?goodsId=" + suppGoodsId + "&productId=" + productId, {
            goodsId: suppGoodsId,
            productId: productId
        }, {
            title: "商品权益",
            width: 1050,
            iframe: true
        });
    });

    //商品描述
    $(".desc").bind("click", function () {
        var suppGoodsId = $(this).attr("data");
        var productId = $("input[name='productId']").val();
        descDialog = new xDialog("/vst_admin/finance/goods/showSuppGoodsDescMain.do?goodsId=" + suppGoodsId + "&productId=" + productId, {
            goodsId: suppGoodsId,
            productId: productId
        }, {
            title: "商品描述",
            width: 1050,
            iframeHeight: 1000,
            iframe: true
        });
    });

    //下单必填项
    $(".orderRequire").bind("click", function () {
        var suppGoodsId = $(this).attr("data");
        var categoryId = $("#categoryId").val();
       // location.href = "/vst_admin/finance/goods/showSuppGoodsOrderRequired.do?suppGoodsId=" + suppGoodsId + "&categoryId=" + categoryId;
    	 orderRequierd = new xDialog("/vst_admin/finance/goods/showSuppGoodsOrderRequired.do?suppGoodsId=" + suppGoodsId + "&categoryId=" + categoryId,{},{title:"商品下单必填项",iframe:true,width:"1000",height:"600"});
    });

    //复制商品
    $(".copyGoods").bind("click", function () {
        var suppGoodsId = $(this).attr("data");
        var productId = $("input[name='productId']").val();
        var categoryId = $("input[name='prodProduct.bizCategory.categoryId']").val();
        var oldSupplierId = $("#supplierId").val();
        var oldSupplierName = $("#supplierName").val();
        if (oldSupplierId == "" || oldSupplierName == "") {
            $.alert("请重新选择供应商，点击查询供应商商品后再复制商品！");
            return false;
        }
        if (productId == "" || suppGoodsId == "" || categoryId == "") {
            $.alert("产品ID、商品ID、品类不能为空！");
            return false;
        }
        descDialog = new xDialog("/vst_admin/finance/goods/showCopyGoods.do", {
            suppGoodsId: suppGoodsId,
            productId: productId,
            categoryId: categoryId,
            oldSupplierId: oldSupplierId,
            oldSupplierName: oldSupplierName
        }, {title: "复制商品", height: 700, width: 600});
    });

    $("#supplierName").change(function () {
        $("#contractName").text("");
        $("#contractId").val("");
    });

    function confirmAndRefresh(result) {
        if (result.code == "success") {
            pandora.dialog({
                wrapClass: "dialog-mini", content: result.message, okValue: "确定", ok: function () {
                    $("#searchForm").submit();
                }
            });
        } else {
            pandora.dialog({
                wrapClass: "dialog-mini", content: result.message, okValue: "确定", ok: function () {
                    $.alert(result.message);
                }
            });
        }
    };
</script>
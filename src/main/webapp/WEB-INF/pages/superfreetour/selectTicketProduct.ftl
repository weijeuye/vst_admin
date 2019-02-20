<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
    <style type="text/css">
        .table_center td {
            white-space: nowrap;
        }
        .table_center .productName {
            min-width: 120px;
            white-space: normal;
        }
        .goodsTable td {
            white-space: nowrap;
            text-align: left;
            table-layout: fixed;
            border: 0px;
            padding: 2px 2px;
        }
    </style>
</head>
<body style="min-height: 800px; min-width: 900px;">
<div class="iframe_content">
    <div class="p_box box_info">
        <form method="post" action='/vst_admin/superfreetour/travelRecommendRoute/showSelectProductList.do' id="searchForm">
            <input type="hidden" id="subCategoryId" name="subCategoryId" value="${subCategoryId!'' }"/>
            <input type="hidden" id="selectCategoryId" name="selectCategoryId" value="${selectCategoryId }"/>
            <input type="hidden" id="redirectType" name="redirectType" value="${redirectType }"/>
            <table class="s_table">
                <tbody>
                <tr>
                    <td class="s_label">产品品类：</td>
                    <td class="w18">
                        <select name="bizCategory.categoryId" >
                        <#list selectCategoryList as bizCategory>1
                            <#if selectCategoryId == bizCategory.categoryId>
                                <option value="${bizCategory.categoryId}">${bizCategory.categoryName}</option>
                            </#if>
                        </#list>
                        </select>
                    </td>
                    <td class="s_label">产品名称：</td>
                    <td class="w18"><input type="text" name="productName" value="${prodProduct.productName!''}" /></td>
                    <td class="s_label">产品ID：</td>
                    <td class="w18"><input type="text" name="productId" value="${prodProduct.productId!''}" number="true" ></td>
                    <td><a class="btn btn_cc1" id="search_button">查询</a></td>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
    <!-- 主要内容显示区域\\ -->
<#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
        <div class="p_box box_info">
            <table class="s_table">
                <tbody>
                <tr style="width:100%;">
                    <td><input type="checkbox" name="" id="selectAllItems" />全选/全不选</td>
                </tr>
                </tbody>
            </table>
            <table class="p_table table_center">
                <thead>
                <th>选择</th>
                <th>产品ID</th>
                <th>产品名称</th>
                </tr>
                </thead>
                <tbody>
                    <#list pageParam.items as product>
                    <tr>
                        <td>
                            <input type="checkbox" name="productIds" data-name="${product.productName!''}" value="${product.productId!''}" />
                        </td>
                        <td>${product.productId!''} </td>
                        <td class="productName">
                            <a style="cursor:pointer"
                               onclick="openProduct(${product.productId!''},${product.bizCategoryId!''},'${product.bizCategoryName!''}')">
                            ${product.productName!''}
                            </a>
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
    <!-- //主要内容显示区域 -->

    <div class="p_box box_info clearfix mb20">
        <div class="fl operate"><a class="btn btn_cc1" id="saveDetail">加入宝典</a></div>
    </div>

</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list.js"></script>
<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>

<script>
    vst_pet_util.districtSuggest("#bizDistrictName", "input[name=bizDistrictId]");
    vst_pet_util.destListSuggest("#destName", "input[id=destReId]");
    $(function(){

        //查询
        $("#search_button").bind("click",function(){
            if(!$("#searchForm").validate().form()){
                return false;
            }
            $("#searchForm").submit();
        });

        $("#saveDetail").bind("click",function(){
            var productIds = "";
            var productData = [];
            $('input[name="productIds"]:checked').each(function(){
                var one={
                    productId:$(this).val(),
                    productName:$(this).attr("data-name")
                }
                productData.push(one);
            });
            if(productData.length == 0){
                alert("请选择产品....");
                return;
            }
            window.console && console.log(productData);
            parent && parent.selectTickCallBack(productData);
        });

        //全选/全不选
        $("#selectAllItems").click(function(){
            var allItem = $("input[name='productIds']");
            if($(this).attr("checked")) {
                allItem.each(function(index, dom){
                    $(dom).attr("checked", true);
                });
            } else {
                allItem.each(function(index, dom){
                    $(dom).attr("checked", false);
                });
            }
        });
    });

    function openProduct(productId, categoryId, categoryName){
        window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
    }

</script>

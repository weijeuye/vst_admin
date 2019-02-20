<#--页眉-->
<#import "/base/spring.ftl" as spring/>
<#import "/base/pagination.ftl" as pagination>
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
<#--页面导航-->
<div class="p_box" id="logResultList">
        <table class="p_table table_center product">
            <thead> 
                    <tr class="noborder">
                	<th class="w10"><input type="checkbox" class="checkbox_top" name="All" id="selectAllItems"></th>
                    <th class="w10">产品类型</th>
                    <th class="w10 text_left">产品ID</th>
                    <th class="w30 text_left">产品名称</th>
                    <th class="w10 text_left">规格ID</th>
                    <th class="w10 text_left">规格</th>
                    <th class="w30 text_left"<#if hiddenFlag="Y">style="display:none;"</#if>>商品</th>
                </tr>
            </thead>
            <tbody>
               
                <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt;  0>
                <#list pageParam.items  as ppb>
                <tr>
                	<td class="w10" align="center">
                        <input type="checkbox" <#if ppb.suppGoodsList?? && ppb.suppGoodsList?size gt 0> class="checkbox_top ckbBranch" name="productBranchIds" value="${ppb.productBranchId!''}"
                               <#else>disabled="disabled"</#if>/>
                    </td>
                    <td class="w10">${ppb.product.bizCategory.categoryName}</td>
                    <td class="w10 text_left">${ppb.product.productId}</td>
                    <td class="w30 text_left"><a style="cursor:pointer"
                                                 onclick="openProduct(${ppb.product.productId!''},${ppb.product.bizCategory.categoryId!''},'${ppb.product.bizCategory.categoryName!''}')">
                    ${ppb.product.productName!''}
                    </a></td>
                    <td class="w10 text_left">${ppb.productBranchId}</td>
                    <td class="w10">${ppb.branchName}
                    
                    <td class="w30 text_left"<#if hiddenFlag="Y">style="display:none;"</#if>>
                        <#if ppb.suppGoodsList?? && ppb.suppGoodsList?size gt 0>
                            <table class="goodsTable" border="0" cellpadding="0" cellspacing="0">
                                <#list ppb.suppGoodsList as goods>
                                    <tr name="supplierId_${goods.supplierId}_${ppb.productBranchId!''}">
                                        <td >${goods.supplierName!''}：</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;<input type="checkbox" name="pb_${ppb.productBranchId!''}" productBranchId="${ppb.productBranchId!''}" supplierId="${goods.supplierId}" value="${goods.suppGoodsId}" />
                                        ${goods.goodsName!''}&nbsp;${goods.suppGoodsId}&nbsp;
	                                        <#if isDestinationBU?? && isDestinationBU=='Y'>
											<font color="#FF0000"><#if goods.aperiodicFlag?? && goods.aperiodicFlag=='Y'>期票<#else>普通票</#if></font>
											</#if>
										</td>
                                    </tr>
                                </#list>
                            </table>
                        <#else>
                            <span style="color:red;">无可售商品</span>
                        </#if>
                    </td>
					
                </tr>
                </#list>
                <#else>
                <tr class="table_nav"><td colspan="6"><div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div></td>	</tr>
                </#if>
            </tbody>
        </table>
        <input type="hidden" name="suppGoodsIds" id="suppGoodsIds" value="" />
        <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt;  0>
        <div class="pages darkstyle">	
        	<@pagination.paging pageParam true "#logResultList"/>
		 </div>
	 </#if>
  </div>
<script>

    $(function(){



        $("#saveDetail").bind("click",function(){
            var branchIds = "",suppGoodsIds = "";
            var subCategoryId = $("#subCategoryId").val();
            $('input[name="branchIds"]:checked').each(function(){
                branchIds += $(this).val() + ",";
                if (subCategoryId == 181) {
                    var goodsIds = "";
                    $("input[name='pb_"+$(this).val()+"']:checked").each(function(){
                        goodsIds += $(this).val() + ",";
                    });
                    suppGoodsIds += goodsIds.substring(0,goodsIds.length - 1)+";";
                }
            });
            if(branchIds == null || branchIds.length == 0){
                $.alert("请选择产品....");
                return;
            }
            if(branchIds != null){
                branchIds = branchIds.substring(0,branchIds.length - 1);
                if (subCategoryId == 181) {
                    suppGoodsIds = suppGoodsIds.substring(0,suppGoodsIds.length - 1);
                }
                var groupId = $("#groupId").val();
                var groupType = $("#groupType").val();
                var selectCategoryId = $("#selectCategoryId").val();
                var postData = "groupId=" + groupId + "&groupType=" + groupType + "&branchIds=" + branchIds+ "&selectCategoryId=" + selectCategoryId+"&suppGoodsIds="+suppGoodsIds;
                var loading = top.pandora.loading("正在努力保存中...");
                $.ajax({
                    url : "/vst_admin/productPack/line/addGroupDetail.do",
                    type : "post",
                    dataType : 'json',
                    data : postData,
                    success : function(result) {
                        loading.close();
                        if(result.code == "success"){
                            var packGroupDetail = {};
                            packGroupDetail.groupId = result.attributes.groupId;
                            packGroupDetail.groupType = result.attributes.groupType;
                            packGroupDetail.selectCategoryId = result.attributes.selectCategoryId;
                            packGroupDetail.detailIds = result.attributes.detailIds;
                            parent.onSavePackGroupDetail(packGroupDetail);
                        }
                        if(result.code == "error"){
                            $.alert(result.message);
                        }
                    },
                    error : function(result) {
                        loading.close();
                        $.alert(result.message);
                    }
                });
            }
        });

        //董宁波2016年9月6日10:09:30
        //级联操作
        $(".ckbBranch").change(function(e){
            var productBranchId = $(this)[0].value;
            var checked = $(this)[0].checked;
            checkedSuppGoods(productBranchId, checked);
        });
        //响应列头的checkbox，选中/取消 商品选择
        function checkedSuppGoods(productBranchId, checked) {
            if (checked) {
                $("input[name='pb_"+productBranchId+"']").attr("checked","checked");
            } else {
                $("input[name='pb_"+productBranchId+"']").removeAttr("checked");
            }
        }
        //级联操作
        $("input[name^='pb_']").bind("click",function(){
            var productBranchId = $($(this)[0]).attr("productBranchId");
            var checked = $("input[name^='pb_"+productBranchId+"']:checked").length;
            if (checked > 0) {
                $("input[value='"+productBranchId+"']").attr("checked","checked");
            } else {
                $("input[value='"+productBranchId+"']").removeAttr("checked");
            }
        });
        //end

        //全选/全不选
        $("#selectAllItems").click(function(){
            var allItem = $("input[name='productBranchIds']");
            if($(this).attr("checked")) {
                allItem.each(function(index, dom){
                    checkedSuppGoods(dom.value, true);
                    $(dom).attr("checked", true);
                });
            } else {
                allItem.each(function(index, dom){
                    checkedSuppGoods(dom.value, false);
                    $(dom).attr("checked", false);
                });
            }
        });
        //将相同供应商的商品合并
        mergerSupplier();
    });
    //将相同供应商的商品合并
    function mergerSupplier() {
        $("tr[name^='supplierId_']").each(function(index, dom){
            var supplierAry = $("tr[name='"+dom.attributes.name.value+"']");
            var len = supplierAry.length;
            if(len==1){		//只有一个
                return true;
            }
            //多个供应商
            for (var i=1;i<len;i++) {
                //将第二次出现的供应商下的商品，移动到同一个供应商下
                $(supplierAry[i]).next().insertAfter($(supplierAry[0]).next()).children();
                //删除多余供应商
                $(supplierAry[i]).remove();
            }
        });
    }

    function openProduct(productId, categoryId, categoryName){
        window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
    }

</script>

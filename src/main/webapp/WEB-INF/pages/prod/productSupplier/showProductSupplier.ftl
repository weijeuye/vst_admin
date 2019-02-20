
<!DOCTYPE html>
<html>
<#include "/base/head_meta.ftl"/>
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/ui-common.css" type="text/css" />
    <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/ui-components.css" type="text/css"/>
    <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/iframe.css" type="text/css"/>
    <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/dialog.css" type="text/css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/buttons.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst/round/v1/vst-backstage-product.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/dialog.css">
</head>
<body>

<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">首页</a> &gt;</li>
        <li><a href="#">产品管理</a> &gt;</li>
        <li class="active">更换产品供应商</li>
    </ul>
</div>

<div class="iframe_content">
    <!-- 筛选 开始 -->
    <div class="filter">
        <form class="filter-form" id="showProductSupplierForm" action="/vst_admin/prod/changeProductSupplier/showProductSupplier.do" method="post">
            <input type="hidden" id="redirectType" name="redirectType" value="${redirectType}"/>
            <div class="row">
                <div class="col">
                    <div class="form-group">
                        <label>
                            <span class="w80 inline-block text-right">产品ID:</span>
                            <textarea name="productIds" id="productIds" class="searchTextarea w850" placeholder="产品编号中可输入多个产品ID，ID间用“，”分隔，最多可同时查询15个产品" >${productSupplier.productIds}</textarea>
                        </label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <div class="form-group">
                        <label>
                            <span class="w80 inline-block text-right">供应商名称:</span>
                            <input type="text" class="search w260 " name="supplierName" id="supplierName" value="${productSupplier.supplierName}">
                        </label>
                    </div>
                    <div class="form-group">
                        <label>
                            <span class="w80 inline-block text-right">供应商ID:</span>
                            <input type="text" class="w200" name="supplierId" id="supplierId" value="${productSupplier.supplierId}">
                        </label>
                    </div>
                    <div class="form-group">
                        <label>
                            <span class="w80 inline-block text-right">产品品类:</span>
                            <select class="form-control w200" name="productType">
                                <#assign  productType="${productSupplier.productType}"/>
                                <option value="" <#if  productType==""> selected="selected" </#if> >不限</option>
                                <option value="INNER_15" <#if productType?? && productType=='INNER_15'> selected="selected"</#if> >国内跟团</option>
                                <option value="INNER_16" <#if productType?? && productType=='INNER_16'> selected="selected"</#if>>国内当地</option>
                                    <option value="FOREIGN_15" <#if productType?? && productType=='FOREIGN_15'> selected="selected"</#if>>出境跟团</option>
                                    <option value="FOREIGN_16" <#if productType?? && productType=='FOREIGN_16'> selected="selected"</#if>>出境当地</option>
                                    <option value="FOREIGN_18" <#if productType?? && productType=='FOREIGN_18'> selected="selected"</#if>>出境自由行</option>
                            </select>
                        </label>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <div class="form-group text-right w950">
                        <a href="javascript:" class="btn btn-lg js_optlog">操作日志</a>
                        <a href="javascript:" class="btn btn-lg btn-blue" id="showProductSupplierBtn">查询</a>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <!-- 筛选 结束 -->

    <!-- 主要内容显示区域\\ -->
    <div class="p_box box_info proliSupplier">
    <#if ProdSupplierInfoVoList??&& ProdSupplierInfoVoList?size gt 0>
        <table class="p_table table_center js_check">
            <colgroup>
                <col class="w40">
                <col class="w90">
                <col class="w90">
                <col class="w350">
                <col class="w200">
                <col class="w500">
                <col class="w200">
                <col class="w500">
                <col class="w350">
            </colgroup>
            <thead>
            <tr>
                <th>选择</th>
                <th>产品ID</th>
                <th>供应商ID</th>
                <th>供应商名称</th>
                <th>非结算对象ID</th>
                <th>非结算对象名称</th>
                <th>买断结算对象ID</th>
                <th>买断结算对象名称</th>
                <th>商品合同</th>
            </tr>
            </thead>
            <tbody>

                <#list ProdSupplierInfoVoList as item >
                <tr>
                    <td><label><input type="checkbox"></label></td>
                    <td data-tag="productId">${item.productId}</td>
                    <td data-tag="supplierId">${item.supplierId!''}</td>
                    <td data-tag="supplierName">${item.supplierName!''}</td>
                    <td data-tag="suppSettlementEntityCode">${item.suppSettlementEntityCode!''}</td>
                    <td data-tag="suppSettlementEntityName">${item.suppSettlementEntityName!''}</td>
                    <td data-tag="buyoutSuppSettlementEntityCode">${item.buyoutSuppSettlementEntityCode!''}</td>
                    <td data-tag="buyoutSuppSettlementEntityName">${item.buyoutSuppSettlementEntityName!''}</td>
                    <td data-tag="contractName">${item.contractName}</td>
                </tr>
                </#list>
            </tbody>
        </table>
        <div class="searchBottom clearfix">
            <div class="searchAll fl">
                <label class="js_selectAll"><input type="checkbox"> 全选</label>
                <span class="searchAll-cheacked">已选择<strong>0</strong>条记录</span>
                <a href="javascript:" class="btn btn-lg btn-blue fr js_changeSupplier">更换供应商</a>
            </div>

        <#if pageParam.items?exists>
            <div class="paging" >
            ${pageParam.getPagination()}
            </div>
        </#if>
        </div>
    <#else>
        <!-- 无结果 -->
        <div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
    </#if>

    </div><!-- div p_box -->
</div><!-- //主要内容显示区域 -->

<div style="display: none" id="hiddenData">
    <form name="updateProductSupplierForm" id="updateProductSupplierForm" action="/vst_admin/prod/changeProductSupplier/updateProductsSupplier.do"  method="post">
        <input type="hidden" id="productIds" name="productIds"/>
        <input type="hidden" id="oldSupplierId" name="oldSupplierId"/>
        <input type="hidden" id="oldSupplierName" name="oldSupplierName"/>
        <input type="hidden" id="supplierId" name="supplierId"/>
        <input type="hidden" id="supplierName" name="supplierName" />
        <input type="hidden" id="contractId" name="contractId"/>
        <input type="hidden" id="contractName" name="contractName" />
        <input type="hidden" id="supplierGroupName" name="supplierGroupName"/>
        <input type="hidden" id="supplierGroupId" name="supplierGroupId" />
        <input type="hidden" id="settlementEntityName" name="suppSettlementEntityName"/>
        <input type="hidden" id="suppSettlementEntityCode" name="suppSettlementEntityCode" />
        <input type="hidden" id="buyoutSuppSettlementEntityName" name="buyoutSuppSettlementEntityName"/>
        <input type="hidden" id="buyoutSuppSettlementEntityCode" name="buyoutSuppSettlementEntityCode" />
        <input type="hidden" id="oldSupplierGroupName" name="oldSupplierGroupName"/>
        <input type="hidden" id="oldSupplierGroupId" name="oldSupplierGroupId" />
        <input type="hidden" id="companyType" name="companyType" />
    </form>

</div>
<!-- 供应商合同确认弹窗内容 -->
<div class="contractConfirm">


</div>
<script src="http://pic.lvmama.com/min/index.php?f=/js/lv/dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>

<#include "/base/foot.ftl"/>
</body>
</html>
<script>
    vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','${suppJsonList}');
</script>
<script>
    //弹层方法
    var changeSupplier = {

        //选择合同再次确认弹窗
        contractConfirm: function(elem) {
            nova.dialog({
                content: $(".contractConfirm").html(),
                okCallback: function() {
                    $(".changeSupplierDialog").find(".btn-blue").addClass("btn-forbidden");
                    updateProductSupplier(this,elem);
                },
                cancelCallback: true,
                okText: "确定",
                cancelText: "取消",
                okClassName: "btn-blue",
                title: "再次确认",
                width: 775,
                initHeight: 200,
                wrapClass: 'changeSupplierDialog '
            });
        }
    };
    /**
     * 更换供应商表单提交
     */
    function updateProductSupplier(that,elem) {
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "/vst_admin/prod/changeProductSupplier/updateProductsSupplier.do" ,
            data: $('#updateProductSupplierForm').serialize(),
            success: function (result) {
                $(".changeSupplierDialog").find(".btn-blue").removeClass("btn-forbidden");
                console.log(result);
                if (result.code == "success") {
                    $.alert(result.message);
                    that.close(true);//关闭当前(再次确认)弹窗
                    elem.close(true);//关闭选择合同弹窗
                    window.location.reload();
                    return false;
                  /*  nova.dialog({
                        content:result.message,
                        okCallback: function () {
                            that.close(true);//关闭当前(再次确认)弹窗
                            elem.close(true);//关闭选择合同弹窗
                            window.location.reload();
                            return false;
                        },
                        okText: "确定",
                        okClassName:"btn-blue"
                        //time:2000 //定时关闭
                    });*/
                }else{
                    $.alert(result.message);
                }
                ;
            },
            error : function() {
                alert("网络异常，请稍后重试！");
            }
        });
    }
    $(function () {
        var $allCheckBox = $('.js_check input[type="checkbox"]');
        var $searchNum = $('.searchAll-cheacked strong');

        $('.js_check').on('click','input[type="checkbox"]',function () {
            var $this = $(this);
            checkNum();
        });

        //全选
        $('.js_selectAll').click(function () {
            var $me = $(this),
                    $iptStatu = $me.find("input").is(":checked");
            $iptStatu ? $me.addClass("selectEd") : $me.removeClass('selectEd');
            $allCheckBox.each(function () {
                var $this = $(this);
                if ($iptStatu) {
                    //全选
                    !$this.is(":checked") &&  $this.prop("checked",true);
                } else {
                    //取消全选
                    $this.is(":checked") &&  $this.prop("checked",false);
                }
            });
            checkNum();
        });

        function checkNum() {
            $searchNum.text($('.js_check input[type="checkbox"]:checked').length);
        }
        var prodArray=new Array();
        function getSelectProducts() {
            prodArray=[];
            $(".proliSupplier tbody tr").each(function () {
                if($(this).find("input").is(":checked")){
                   var prod={};
                    prod.productId=$(this).find("td[data-tag='productId']").text();
                    prod.supplierId=$(this).find("td[data-tag='supplierId']").text();
                    prod.supplierName=$(this).find("td[data-tag='supplierName']").text();
                    prod.contractName=$(this).find("td[data-tag='contractName']").text();
                    prodArray.push(prod);
                }
            })
        };
        function getSelectProductsAndSupplier(prodArray) {
            productIdStr="";
            supplierIds=[];
            productsArray=[];
            for(var i=0;i<prodArray.length;i++){
                if (i==0){
                    productIdStr=productIdStr+prodArray[i].productId;
                }else {
                    productIdStr=productIdStr+","+prodArray[i].productId;
                }
                supplierIds.push(prodArray[i].supplierId);
                productsArray.push(prodArray[i].productId)
            }
            if(isHasOneSupplier(supplierIds)){
                $("#hiddenData").find("#oldSupplierId").val(prodArray[0].supplierId);
                $("#hiddenData").find("#oldSupplierName").val(prodArray[0].supplierName);
            }else {
                $("#hiddenData").find("#oldSupplierId").val("");
                $("#hiddenData").find("#oldSupplierName").val("");
            };
             $("#hiddenData").find("#productIds").val(productsArray);
        }

        // 打开更换供应商弹层
        var changeSupplierUrl="/vst_admin/prod/changeProductSupplier/selectSupplier.do";
        var productIdStr="";
        var supplierIds =new Array();
        var productsArray=new Array();
        $(document).on('click','.js_changeSupplier',function() {
            getSelectProducts();
            if(prodArray && prodArray.length > 0){
                getSelectProductsAndSupplier(prodArray);
            }else {
                $.alert("请先选择产品！");
                return;
            }
            nova.dialog({
                url: true,
                content: changeSupplierUrl,
                //okCallback: true,
                okCallback: function(){
                    if($(".changeSupplierDialog").find(".btn-blue").hasClass("btn-forbidden")){
                        return false;
                    }
                    var getSupplierContractInfo=$(".iframe2 iframe")[0].contentWindow.getSupplierContractInfo();
                    if(getSupplierContractInfo && getSupplierContractInfo!=null){
                            var $hiddenData=$("#hiddenData");
                            $hiddenData.find("#supplierId").val(getSupplierContractInfo.supplierId)
                            $hiddenData.find("#supplierName").val(getSupplierContractInfo.supplierName);
                            $hiddenData.find("#contractId").val(getSupplierContractInfo.contractId);
                            $hiddenData.find("#contractName").val(getSupplierContractInfo.contractName);
                            $hiddenData.find("#supplierGroupName").val(getSupplierContractInfo.supplierGroupName);
                            $hiddenData.find("#supplierGroupId").val(getSupplierContractInfo.supplierGroupId);
                            $hiddenData.find("#settlementEntityName").val(getSupplierContractInfo.settlementEntityName);
                            $hiddenData.find("#suppSettlementEntityCode").val(getSupplierContractInfo.settlementEntityCode);
                            $hiddenData.find("#buyoutSuppSettlementEntityName").val(getSupplierContractInfo.buyoutSettlementEntityName);
                            $hiddenData.find("#buyoutSuppSettlementEntityCode").val(getSupplierContractInfo.buyoutSettlementEntityCode);
                            $hiddenData.find("#oldSupplierGroupName").val(getSupplierContractInfo.oldSupplierGroupName);
                            $hiddenData.find("#oldSupplierGroupId").val(getSupplierContractInfo.oldSupplierGroupId);
                            $hiddenData.find("#companyType").val(getSupplierContractInfo.companyType);
                        getSelectProductsAndSupplier(prodArray);
                        buildConfirmHtml();
                    }else {
                        return false;
                    }
                    //选择供应商合同确认
                    changeSupplier.contractConfirm(this);
                    return false;
                },
                cancelCallback: true,
                okText: "保存",
                cancelText: "取消",
                okClassName: "btn-blue",
                title: "更换供应商",
                width: 800,
                initHeight: 400,
                wrapClass: 'changeSupplierDialog iframe2'
            });
        });

        //操作日志弹层
        $(document).on('click','.js_optlog',function() {
            var url="http://super.lvmama.com/lvmm_log/bizLog/showVersatileLogList?objectType=PROD_PRODUCT_SUPPLIER";
            nova.dialog({
                url: true,
                content: url,
                title: "操作日志",
                width: 1000,
                initHeight: 800,
                wrapClass: 'changeSupplierDialog'
            });
        });


        //点击查询提交表单
        $(document).on('click','#showProductSupplierBtn',function () {
            var validateFlag = validateInput();
            if(!validateFlag){
                return;
            }
            $('#showProductSupplierForm').submit();
        });

        /**
         * 校验查询前条件是否符合要求
         **/
        function validateInput(){
            //产品id不得大于15个
            var productIdsStr = $("#productIds").val();
            var supplierName = $("#supplierName").val();
            var supplierId = $("#supplierId").val();
            var numberTest = /^[0-9]*[1-9][0-9]*$/;
            if(productIdsStr != null && productIdsStr != ""){
                var productIdsArr = productIdsStr.split(",");
                if(productIdsArr != null && productIdsArr.length>15){
                    $.alert("最多一次查询15个产品！");
                    return false;
                }
               if(productIdsArr != null){
                    for(var i=0;i<productIdsArr.length;i++){
                        if(!numberTest.test(productIdsArr[i])){
                            $.alert("请检查产品ID中【"+productIdsArr[i]+"】是否输入正确！");
                            return false;
                        }
                    }
               }
              }
              if(supplierId && supplierId !=""){
                if(!numberTest.test(supplierId)){
                    $.alert("请输入正确的供应商ID!");
                    return false;
                }
              }
            if(productIdsStr=="" && supplierName=="" && supplierId==""){
                $.alert("产品ID、供应商名称、供应商ID不能全部为空！");
                return false;
            }
            return true;
        }

        /**
         * 判断更换产品老的供应商是不是同一个
         * @param arr
         * @returns {boolean}
         */
        function isHasOneSupplier(arr){
            var bool=true;
            for(var i=1,len=arr.length;i<len;i++){
                if(arr[i]!==arr[0]){bool=false}
            }
            return bool
        }

        /**
         * 构建更换供应商确认页面
         */
        function buildConfirmHtml() {
            var html="将产品ID为："+productIdStr+"的供应商";
            var $hiddenData=$("#hiddenData");
             var oldSupplierName =$hiddenData.find("#oldSupplierName").val();
            if(oldSupplierName && oldSupplierName!=""){
                html=html+"由"+oldSupplierName;
            }
            var supplierName =$hiddenData.find("#supplierName").val();
            if(supplierName && supplierName !=""){
                html=html+"改为："+supplierName+"。";
            }
            $(".contractConfirm").html(html);
        }
    });
</script>

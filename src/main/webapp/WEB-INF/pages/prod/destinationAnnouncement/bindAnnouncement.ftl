<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>绑定产品</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/active.css"/>
</head>
<body class="active">
     <div class="baseInformation" style="height: 700px">
            <div class="tab-box main">
                <form id="searchForm" action="/vst_admin/prod/destinationAnnouncement/queryProductList.do" method="post">
                    <input type="hidden" name="announcementId" id="announcementId" value="${announcementId}">
                    <div class="fuzzy clearfix">
                        <div class="row clearfix">
                            <div class="col w260">
                                <label>
                                    <span class="w75 inline-block">产品名称：</span>
                                    <div class="form-group inline-block">
                                        <input class="form-control w170" id="productName" name="productName" type="text" value="${productName!''}"/>
                                    </div>
                                </label>
                            </div>
                        <div class="col w155">
                            <label>
                                <span class="w80 inline-block">是否有效：</span>
                                <select class="form-control w70" name="cancelFlag">
                                    <option value="" <#if cancelFlag?? && cancelFlag==''>selected="selected"</#if>>不限</option>
                                    <option value="Y" <#if cancelFlag?? && cancelFlag=='Y'>selected="selected"</#if>>有效</option>
                                    <option value="N" <#if cancelFlag?? && cancelFlag=='N'>selected="selected"</#if>>无效</option>
                                </select>
                            </label>
                        </div>
                        <div class="col w155">
                            <label>
                                <span class="w80 inline-block">是否可售：</span>
                                <select class="form-control w70" name="saleFlag">
                                    <option value="" <#if saleFlag?? && saleFlag==''>selected="selected"</#if>>不限</option>
                                    <option value="Y" <#if saleFlag?? && saleFlag=='Y'>selected="selected"</#if>>是</option>
                                    <option value="N" <#if saleFlag?? && saleFlag=='N'>selected="selected"</#if>>否</option>
                                </select>
                            </label>
                        </div>
                        <div class="col w155">
                            <label>
                                <span class="w80 inline-block">产品品类：</span>
                                <select class="form-control w70" name="categoryCode">
                                    <option value="" <#if categoryCode?? && categoryCode==''>selected="selected"</#if>>不限</option>
                                    <option value="category_hotel" <#if categoryCode?? && categoryCode=='category_hotel'>selected="selected"</#if>>酒店</option>
                                    <option value="category_route_hotelcomb" <#if categoryCode?? && categoryCode=='category_route_hotelcomb'>selected="selected"</#if>>酒店套餐</option>
                                    <option value="category_route_freedom" <#if categoryCode?? && categoryCode=='category_route_freedom'>selected="selected"</#if>>自由行</option>
                                </select>
                            </label>
                        </div>
                    </div>
                    <div class="row clearfix">
                        <div class="col w260">
                            <label>
                                <span class="w75 inline-block">产品ID：</span>
                                <input class="form-control w170" id="productId" name="productId" type="text" value="${productId!''}"/>
                            </label>
                        </div>
                        <div class="col w160">
                            <label>
                                <span class="w70 inline-block">产品经理：</span>
                                <div class="form-group inline-block">
                                    <input id="productManager" type="text"
                                           class="form-control search w70 JS_autocomplete_pm"
                                           data-validate="{required:true}" value="${productManagerName!''}"/>
                                    <input type="hidden" class="JS_autocomplete_pm_hidden" id="productManagerId"
                                           name="managerId" value="${managerId!''}"/>
                                    <!--<input type="hidden" class="JS_autocomplete_f_hidden_email" id="FounderEmail"-->
                                    <!--name="FounderEmail"/>-->
                                </div>
                            </label>
                        </div>
                        <div class="col w170">
                            <label>
                                <span class="w80 inline-block">供应商名称：</span>
                                <div class="form-group inline-block">
                                    <input id="supplierName" type="text"
                                           class="form-control search w70 JS_autocomplete_s"
                                           data-validate="{required:true}" value="${supplierName!''}"/>
                                    <input type="hidden" class="JS_autocomplete_s_hidden" id="supplierNameId"
                                           name="supplierId" value="${supplierId!''}"/>
                                    <!--<input type="hidden" class="JS_autocomplete_f_hidden_email" id="FounderEmail"-->
                                    <!--name="FounderEmail"/>-->
                                </div>
                            </label>
                        </div>
                        <div class="col w155">
                            <label>
                                <span class="w65 inline-block">所属公司：</span>
                                <select class="form-control w70" name="subCompany">
                                    <option value="">不限</option>
								<#list filialeNameList as filiale>
                                    <option value="${filiale.code}" <#if subCompany?? && subCompany==filiale.code>selected=selected </#if>  >${filiale.cnName}</option>
								</#list>
                                </select>
                            </label>
                        </div>
                    </div>

                        <div class="active_btn w400">
                            <span class="btn-group">
                                <a class="btn btn-primary " id="search_button" data-announcementId="${announcementId!''}">查询</a>
                                <a class="btn btn-primary " id="batchBind">批量绑定</a>
                            </span>
                        </div>
            </div>
	              </form> 
                <div id="resultUnBind" class="iframe_content mt20"></div>

                <div class="dialog-boundSuccess" style="display: block">
                    <!--查询结果-->
                <#if pageParam??>
                    <div class="boundCheck_result" id="boundCheck_result" style="display: block">
                        <div class="Unbundling" style="display: block">
                            <!--<input type="checkbox" class="verticalMiddle JS_allChecked" id="JS_allChecked1"/>全部产品-->
                            <a class="btn btn-primary btn-unbound JS_allbound">绑定</a>
                        </div>
                        <div class="check_result" style="display: block">
                            <table class="table table-border">
                                <colgroup>
                                    <col class="w60">
                                    <col class="w60">
                                    <col class="w320">
                                    <col class="w100">
                                    <col class="w60">
                                    <col class="w60">
                                    <col class="w60">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th><label><input type="checkbox" class="verticalMiddle JS_allCheckeding"/>当前页</label></th>
                                    <th>产品ID</th>
                                    <th>产品名称</th>
                                    <th>产品品类</th>
                                    <th>是否有效</th>
                                    <th>是否可售</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tbody>
                                    <#list pageParam.items as products>
                                    <tr>
                                        <td class="text-center">
                                        	<input type="checkbox" class="verticalMiddle"/ data-productId="${products.productId}">
                                        </td>
                                        <td class="text-center">${products.productId}</td>
                                        <td class="text-left">${products.productName}</td>
                                        <td class="text-center">${products.bizCategory.categoryName}</td>
                                        <td class="text-center">
							<span class="text-success">
                                <#if products.cancelFlag?? && products.cancelFlag=='Y'>
                                    有效
                                <#else>
                                    无效
                                </#if>
                            </span>
                                        </td>
                                        <td class="text-center">
                                            <#if products.saleFlag?? && products.saleFlag=='Y'>
                                                是
                                            <#else>
                                                否
                                            </#if>
                                        </td>
                                        <td class="text-center">
                                            <p>
                                                <a class="product-link text-danger JS_boundProduct" data-productId="${products.productId}">绑定</a>
                                            </p>
                                        </td>
                                    </tr>
                                    </#list>
                                </tbody>
                            </table>
                            <div class="page-box">
                                <#if pageParam.items?exists>
                                    <div class="page-box" > ${pageParam.getPagination()}</div>
                                </#if>

                            </div>
                        </div>
                    </div>
                <#else>
                    <!--查询无结果-->
                    <div class="check_nodata">
                        <div class="hint mb10">
                            <span class="icon icon-big icon-info icon_bigflow"></span>
                            VST没办法查找到相应产品，换个条件试试？
                        </div>
                    </div>
                </#if>
                </div>
            </div>
     </div>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/active.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js"></script>
<#include "/base/foot.ftl"/>
<script type="text/javascript">
	var oldTitle = window.parent.$(".dialog-header").text();
	oldTitle = oldTitle.substring(0,4);
    var batchBindDialog;
    $(function(){
        //产品经理自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_autocomplete_pm",
                "fillData": fillData,
                "choice": choice,
                "clearData": clearData
            });
            function fillData(self) {
            	var productManager = $("#productManager").val();
                var url = "/vst_admin/pet/permUser/searchUser.do?search="+productManager;
                self.loading();
                $.ajax({
                    url: url,
                    success: function (json) {
                        var $ul = self.$menu.find("ul");
                        $ul.empty();
                        for (var i = 0; i < json.length; i++) {
                            var $li = $('<li  data-id="' + json[i].id + '">' + json[i].text + '</li>');
                            $ul.append($li)
                        }

                        self.loaded();
                    }
                });
            }

            function choice(self, $li) {
                var id = $li.attr("data-id");
                var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
                $hidden.val(id);

            }
            function clearData(self) {
                var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
                $hidden.val("");
            }
        });
        //供应商自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_autocomplete_s",
                "fillData": fillData,
                "choice": choice,
                "clearData": clearData
            });
            function fillData(self) {
           		var supplierName = $("#supplierName").val();
                var url = "/vst_back/supp/supplier/searchSupplierList.do?search="+supplierName;
                self.loading();
                $.ajax({
                    url: url,
                    success: function (json) {
                        var $ul = self.$menu.find("ul");
                        $ul.empty();
                        for (var i = 0; i < json.length; i++) {
                            var $li = $('<li  data-id="' + json[i].id + '">' + json[i].text + '</li>');
                            $ul.append($li)
                        }

                        self.loaded();
                    }
                });
            }
            function choice(self, $li) {
                var id = $li.attr("data-id");
                var $hidden = self.$input.parent().find(".JS_autocomplete_s_hidden");
                $hidden.val(id);

            }
            function clearData(self) {
                var $hidden = self.$input.parent().find(".JS_autocomplete_s_hidden");
                $hidden.val("");
            }
        });

        //绑定其他产品--产品名称自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_autocomplete_pn1",
                "fillData": fillData,
                "choice": choice,
                "clearData": clearData
            });
            function fillData(self) {
           	 	var productName = $("#ProduceName1").val();
                var url = "/vst_admin/prod/promotion/desc/queryProName.do?&productName="+productName;
                self.loading();
                $.ajax({
                    url: url,
                    success: function (json) {
                        var $ul = self.$menu.find("ul");
                        $ul.empty();
                        for (var i = 0; i < json.length; i++) {
                            var $li = $('<li  data-id="' + json[i].productId + '">' + json[i].productName + '</li>');
                            $ul.append($li)
                        }

                        self.loaded();
                    }
                });
            }
            function choice(self, $li) {
                var id = $li.attr("data-id");
                var $hidden = self.$input.parent().find(".JS_autocomplete_pn1_hidden");
                $hidden.val(id);

            }
            function clearData(self) {
                var $hidden = self.$input.parent().find(".JS_autocomplete_pn1_hidden");
                $hidden.val("");
            }
        });
    })
    $(function(){
        //查询
        $("#search_button").bind("click",function(){
            var myreg = /^(([0-9]|,)*)$/;
            if(!myreg.test($("#productId").val()))
            {
                alert('请输入有效的产品ID');
                return false;
            }
            $("#searchForm").submit();
        });

        //选择当前页的全部产品
        $('.JS_allCheckeding').click(function(){
            var check=$(this).attr('checked');
            if(check=='checked')
            {
                $(this).parents('.boundCheck_result').find('.check_result tbody tr').find('input').attr('checked',true);
            }
            else
            {
                $(this).parents('.boundCheck_result').find('.check_result tbody tr').find('input').removeAttr('checked');
            }
        });
        //绑定按钮
        $('.JS_allbound').click(function(){

            var announcementId = $("#announcementId").val();
            var i=0;
            var productIds=[];
            $(this).parents('.boundCheck_result').find('.check_result tbody tr').each(function(){
                //console.log(index);
                var $this=$(this);
                var check=$this.find('input').attr('checked');
                if(check=='checked')
                {
                    i++;
                    var productId =$this.find('input').attr('data-productId');
                    if(productId != null && productId != undefined){
                        productIds.push(productId);
                    }
                }

            });
            if(i==0)
            {
                backstage.alert({
                    content:"请选择产品后再点击此绑定按钮!"
                });
            }
            else
            {
                $.ajax({
                    url: "/vst_admin/prod/destinationAnnouncement/bindProduct.do?productIds="+productIds+"&announcementId="+announcementId,
                    type: "POST",
                    cache: false,
                    dataType : 'json',
                    success:
                            function(data){
                                if(data.code=="success"){
                                    backstage.alert({
                                        content:"绑定成功"
                                    });
                                }else{
                                    backstage.alert({
                                        content:"绑定失败"
                                    });
                                }
                            },
                    error: function () {
                        backstage.alert({
                            content:"绑定失败"
                        });
                    }
                });
            }

        });
        //点击操作栏中的绑定按钮
        $('.JS_boundProduct').click(function(){

            var announcementId = $("#announcementId").val();
            var productId =$(this).attr('data-productId');
            var productIds=[];
            productIds.push(productId);
            $.ajax({
                url: "/vst_admin/prod/destinationAnnouncement/bindProduct.do?productIds="+productIds+"&announcementId="+announcementId,
                type: "POST",
                cache: false,
                dataType : 'json',
                success:
                        function(data){
                            if(data.code=="success"){
                                backstage.alert({
                                    content:"绑定成功"
                                });
                            }else{
                                backstage.alert({
                                    content:"绑定失败"
                                });
                            }
                        },
                error: function () {
                    backstage.alert({
                        content:"绑定失败"
                    });
                }
            });
        });

        //批量绑定
        $("#batchBind").click(function(){
            var announcementId = $("#announcementId").val();
            var url = "/vst_admin/prod/destinationAnnouncement/toBatchBind.do?announcementId="+announcementId;
            batchBindDialog=new xDialog(url,{},{title:"批量绑定",width:890,hight:500});
        });
    })
</script>
</body>
</html>

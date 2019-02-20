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
                <input type="hidden" name="announcementId" id="announcementId" value="${announcementId}">
                <div id="resultUnBind" class="iframe_content mt20"></div>
                <div class="dialog-boundSuccess" style="display: block">
                    <!--查询结果-->
                <#if pageParam??>
                    <div class="boundCheck_result" id="boundCheck_result" style="display: block">
                        <div class="Unbundling" style="display: block">
                            <!--<input type="checkbox" class="verticalMiddle JS_allChecked" id="JS_allChecked1"/>全部产品-->
                            <a class="btn btn-primary btn-unbound JS_allDeleteBound">解绑</a>
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
                                                <a class="product-link text-danger JS_deleteBoundProduct" data-productId="${products.productId}">解绑</a>
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
                            没有已经绑定的产品
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

    $(function(){


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
        //解绑按钮
        $('.JS_allDeleteBound').click(function(){

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
                    url: "/vst_admin/prod/destinationAnnouncement/deleteBindProduct.do?productIds="+productIds+"&announcementId="+announcementId,
                    type: "POST",
                    cache: false,
                    dataType : 'json',
                    success:
                            function(data){
                                if(data.code=="success"){
                                    var $div = $('.Pages');
                                    var page=0;
                                    page = $div.find(".PageSel").text();
                                    var url = $div.attr('url');
                                    url += '&page=' + page;
                                    window.location.href=url;
                                    backstage.alert({
                                        content:"解绑成功"
                                    });
                                }else{
                                    backstage.alert({
                                        content:"解绑失败"
                                    });
                                }
                            },
                    error: function () {
                        backstage.alert({
                            content:"解绑失败"
                        });
                    }
                });
            }

        });
        //点击操作栏中的绑定按钮
        $('.JS_deleteBoundProduct').click(function(){

            var announcementId = $("#announcementId").val();
            var productId =$(this).attr('data-productId');
            var productIds=[];
            productIds.push(productId);
            $.ajax({
                url: "/vst_admin/prod/destinationAnnouncement/deleteBindProduct.do?productIds="+productIds+"&announcementId="+announcementId,
                type: "POST",
                cache: false,
                dataType : 'json',
                success:
                        function(data){
                            if(data.code=="success"){
                                backstage.alert({
                                    content:"解绑成功"
                                });
                                var $div = $('.Pages');
                                var page=0;
                                page = $div.find(".PageSel").text();
                                var url = $div.attr('url');
                                url += '&page=' + page;
                                window.location.href=url;

                            }else{
                                backstage.alert({
                                    content:"解绑失败"
                                });
                            }
                        },
                error: function () {
                    backstage.alert({
                        content:"解绑失败"
                    });
                }
            });
        });
    })
</script>
</body>
</html>

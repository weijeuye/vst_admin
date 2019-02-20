<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>付款流水记录</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/resource_control_setting.css"/>
</head>
<body class="resource-add-control">
<div class="main">

    <form id="findForm">
    	<div class="mt10">
    	      &nbsp;&nbsp;&nbsp;&nbsp;预控资源ID：${precontrolPolicyId}
			  <input type="hidden" class="JS_autocomplete_pm_hidden" id="precontrolPolicyId" value="${precontrolPolicyId}" name="precontrolPolicyId"/>
		</div>
	    <div class="text-right mb5"> 
	          <a class="btn btn-primary JS_add_paymoney">新增</a>
	    </div>
        <div class="resource-table" >
	        <table class="table table-border" style="text-align: center;">
	            <thead>
	                <tr>
	                	<th width="8%">付款流水ID</th>
	                	<th width="12%">付款日期</th>
	                    <th width="13%">付款金额</th>
	                    <th width="15%">操作人</th>
	                    <th width="10%">操作账号</th>
	                    <th width="13%">操作时间</th>
	                    <th width="19%">备注</th>
	                    <th width="10%">操作</th>
	                </tr>
	            </thead>
	
	        <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt; 0>
	            <tbody>
	                <#list pageParam.items as rs>
	                    <tr id = "tr_in_${rs.paymentId!''}">
	                       	<td>${rs.paymentId}</td>
                        	<td>${rs.payDate?string("yyyy-MM-dd")}</td>
                        	<td>${rs.amountYuanStr}</td>
                        	<td>${rs.payPerson}</td>
                        	<td>${rs.operatorId}</td>
                        	<td>
								<#if rs.updateTime??>
									${rs.updateTime?string("yyyy-MM-dd HH:mm:ss")}
								<#else>
									${rs.creatTime?string("yyyy-MM-dd HH:mm:ss")}
								</#if>
							</td>
                        	<td>${rs.memo}</td>
                        	<td>
                        		<a class="editPrecontrolPolicy" href="javascript:void(0);" data="${rs.paymentId!''}" >编辑</a>&nbsp;&nbsp;
                        		<a class="deletePrecontrolPolicy" href="javascript:void(0);" data="${rs.paymentId!''}">删除</a>
                        	</td>
	                    </tr>
	                </#list>
	            </tbody>
	        </#if>
	        </table>
	        
			<#if pageParam.items?size == 0>
		        <div class="hint">
		                <span class="icon icon-info"></span>暂无付款数据
		        </div>
        	</#if>
	        <div class="text-center mt5">
	         	<#if pageParam.items?exists>
					<div class="paging">
					    ${pageParam.getPagination()}
					</div>
				</#if>
	       </div>
	
	    </div><!-- end of table filter-->
	    
		
    </form>
</div>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>

<!-- <#include "/base/foot.ftl"/> -->
</body>
</html>
<script>
    $(function() {
        var $document = $(document);

        function confirmAndRefresh(result,paymentId){
        	if (result.code == "success") {
                location.href="/vst_admin/goods/recontrol/goToResControlPaymentMain/view.do?precontrolPolicyId="+$("#precontrolPolicyId").val();
        	}else {
        	}
        };

        //删除
        $("a.deletePrecontrolPolicy").on("click", function(){
        	var paymentId=$(this).attr("data");
            backstage.confirm({
	            content: "删除不能恢复,确认删除吗？",
	            determineCallback: function() {
	        		$.ajax({
	        			url : "/vst_admin/goods/recontrol/deleteResourceControlPayment.do",
	        			type : "get",
	        			async: false,
	        			data : {paymentId : paymentId},
	        			dataType:'JSON',
	        			success : function(result) {
	        				confirmAndRefresh(result,paymentId);
	        			}
	        		});
	            }
        	});
            
            /* $.confirm("删除不能恢复,确认删除吗？", function () {
        		$.ajax({
        			url : "/vst_admin/goods/recontrol/deleteResourceControlPayment.do",
        			type : "get",
        			async: false,
        			data : {paymentId : paymentId},
        			dataType:'JSON',
        			success : function(result) {
        				confirmAndRefresh(result,paymentId);
        			}
        		});
           }); */
        });
        
        
        //编辑
      /*   $("a.editPrecontrolPolicy").on("click", function(){
        	alert( $(this).text() );
        });
         */
        //新增
        $document.on("click", ".JS_add_paymoney", addPaymentHanlder);
        function addPaymentHanlder() {
            var precontrolPolicyId=$("#precontrolPolicyId").val();
            var url = "/vst_admin/goods/recontrol/goToResControlPaymentAdd/view.do?precontrolPolicyId="+precontrolPolicyId;
              window.dialogViewOrder = backstage.dialog({
                width: 650,
                height: 400,
                title: "新增付款流水",
                iframe: true,
                url: url
            });
        }
        
        //编辑
        $("a.editPrecontrolPolicy").on("click", function(){
            var precontrolPolicyId=$("#precontrolPolicyId").val();
            var paymentId=$(this).attr("data");
            var url = "/vst_admin/goods/recontrol/goToResControlPaymentEdit/view.do?precontrolPolicyId="+precontrolPolicyId+"&paymentId="+paymentId;
              window.dialogViewOrder = backstage.dialog({
                width: 650,
                height: 400,
                title: "编辑付款流水",
                iframe: true,
                url: url
            });
        });
        
        
    });


</script>
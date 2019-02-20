<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>合同签署备案信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="contract-info my-body">
    <p class="main-title">合同签署备案信息</p>
    <div class="main">
        <div>
            <!--筛选 开始-->
            <div class="filter">
                <form class="filter-form clearfix" id="searchContractForm" method="post" action="/vst_admin/o2o/subCompany/contracts.do" >
                	<input type="hidden" id="subCompanyId" name="subCompanyId" <#if contract??>value=${contract.subCompanyId!''}</#if> />
            		<input type="hidden" id="viewType" name="type" value="${type!''}" />
					<input type="hidden" id="auditType" name="auditType" value="${auditType!''}" />
                    <div class="col w650">
                        <div class="row">
                            <div class="col w210">
                                <div class="form-group">
                                    <label>
                                        <span class="w85 inline-block text-right">合同签署方：</span>
                                        <select name="contractSubjectType" class="form-control w110">
		        	 						<option value="">全部</option>
					    					<#list contractSubjectTypes as list>
					                    		<option value=${list.code!''} <#if contract?? && contract.contractSubjectType==list.code>selected</#if> >${list.cnName!''}</option>
						                	</#list>
						        		</select>
                                    </label>
                                </div>
                            </div>
                            <div class="col w210">
                                <div class="form-group">
                                    <label>
                                        <span class="w85 inline-block text-right">合同类型：</span>
                                        <select name="contractType" class="form-control w110">
		        	 						<option value="">全部</option>
					    					<#list contractTypes as list>
					                    		<option value=${list.code!''} <#if contract?? && contract.contractType==list.code>selected</#if> >${list.cnName!''}</option>
						                	</#list>
						        		</select>
                                    </label>
                                </div>
                            </div>
                            <div class="col w210">
                                <div class="form-group">
                                    <label>
                                        <span class="w85 inline-block text-right">距离合同到期：</span>
                                        <select name="timeSort" class="form-control w110">
					    					<#list timeSortList as list>
					                    		<option value=${list.code!''} <#if timeSort?? && timeSort==list.code>selected</#if> >${list.cnName!''}</option>
						                	</#list>
						        		</select>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="pull-right">
                        <a class="btn btn-primary" id="search_contract">查询</a>
                        <#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
                        	<@mis.checkPerm permCode="5120">
	                        	<a class="btn JS_add_ci">新增</a>
                    		</@mis.checkPerm >
						</#if>
                    </div>
                </form>
            </div>
            <!--筛选 结束-->
            <#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
	            <table class="table table-border table_center">
	                <thead>
	                    <tr>
	                        <th width="95">序号</th>
	                        <th width="100">合同签署方</th>
	                        <th width="80">合同类型</th>
	                        <th width="80">合同主体</th>
	                        <th width="180">合同编号</th>
	                        <th width="180">合同有效期</th>
	                        <th width="80">距离合同到期</th>
	                        <th width="220">操作</th>
	                    </tr>
	                </thead>
	                <tbody>
	                <#list pageParam.items as contract>
	                    <tr>
	                    	<td>
	                        	${contract.id!''}
								<#if type?upper_case=="COMPARED" && contract?? && auditType?upper_case=='SUBMITTED'>
									<#if !contract.approveTime??>
				                		<i class="icon icon-warning"></i> 
			                		<#elseif contract?? && contract.delForCompared == 'Y'>
			                			<i class="icon icon-danger"></i>
				                	</#if>
			                	</#if>
	                    	</td>
	                        <td>
	                            <div class="w100 text-ellipsis">
		                			${contract.signerName!''}
								</div>
	                        </td>
	                        <td>
								<#list contractTypes as list>
		                    		<#if contract?? && contract.contractType==list.code && list.code?upper_case!="OTHER">
		                    			${list.cnName}
	                    			<#elseif contract?? && contract.contractType==list.code && list.code?upper_case=="OTHER">
	                    				${list.cnName} ${contract.contractTypeNote!''}
	                    			</#if>
			                	</#list>
							</td>
	                        <td>${contract.contractSubject!''}</td>
	                        <td>
	                            <div class="w180 text-ellipsis">${contract.contractNo!''}</div>
	                        </td>
	                        <td>
	                            <#if contract.startTime??> ${contract.startTime?string("yyyy-MM-dd")}</#if>到<#if contract.endTime??>${contract.endTime?string("yyyy-MM-dd")} </#if>
	                        </td>
	                        <td>
								<#if contract.leftDays==0>
									今天到期
								<#elseif contract.leftDays<0>
									<span style="color:red">超期${-contract.leftDays}天</span>
								<#elseif contract.leftDays &lt; 30 && contract.leftDays &gt; 0>
									<span style="color:blue">即将到期${contract.leftDays}天</span>
								<#else>
									<span style="color:green">${contract.leftDays}天</span>
								</#if>
							</td>
	                        <td>
	                            <#if type?upper_case=="COMPARED">
	                            	<@mis.checkPerm permCode="5121">
		                            	<a class="mr5 JS_view_ci" data-type="COMPARED" data-id="${contract.id}">查看</a>
		                            	<a class="mr5 JS_view_ca" data-type="COMPARED" data-id="${contract.id}">查看合同</a>
	                            	</@mis.checkPerm >
                            	<#elseif type?upper_case!='COMPARED' && contract?? && contract.approveTime??>
                            		<@mis.checkPerm permCode="5119">
	                            		<a class="mr5 JS_view_ci" data-type="READONLY" data-id="${contract.id}">查看</a>
	                            		<a class="mr5 JS_view_ca" data-type="READONLY" data-id="${contract.id}">查看合同</a>
                        			</@mis.checkPerm >
	                            </#if>
	                            <#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
	                            	<@mis.checkPerm permCode="5120">
			                            <a class="mr5 JS_edit_ci" data-type="WRITABLE" data-id="${contract.id}">编辑</a>
			                            <a class="mr5 JS_edit_ca" data-type="WRITABLE" data-id="${contract.id}">编辑合同</a>
			                            <a class="mr5 JS_del_ci" data-id="${contract.id}">删除</a>
		                            </@mis.checkPerm >
	                            </#if>
	                        </td>
	                    </tr>
	                    </#list>
	                </tbody>
	            </table>
	            <#if pageParam.items?exists> 
					<div class="page-box" > ${pageParam.getPagination()}</div> 
				</#if>
				
			<#else>
	            <div class="hint mb10">
	                <span class="icon icon-big icon-info"></span> 抱歉，查询暂无数据
	            </div>
            </#if>
        </div>
    </div>
    
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/base.js"></script>
    <script>
    var dialogContractInfoDetail;
    $(function() {

        var $document = $(document);

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>

		searchContractHandler = function () {
			$("#searchContractForm").submit();
	    }
	    // 查询合同签署备案信息
	    $document.on("click", "#search_contract", searchContractHandler);

        //新增合同签署备案信息
        $document.on("click", ".JS_add_ci", addContractInfoHanlder);
        function addContractInfoHanlder() {
        	var $this = $(this),
            	subCompanyId = $("#subCompanyId").val(),
            	type = $("#viewType").val(),
            	auditType = $("#auditType").val();
        	var url = "/vst_admin/o2o/subCompany/showContractForm.do?subCompanyId="+subCompanyId+"&type="+type+"&auditType="+auditType;
            dialogContractInfoDetail = backstage.dialog({
                width: 760,
                height: 450,
                title: "新增合同签署备案信息",
                iframe: true,
                url: url
            });
        }

        //编辑合同签署备案信息
        $document.on("click", ".JS_edit_ci", editContractInfoHanlder);
        function editContractInfoHanlder() {
            var $that = $(this),
            	subCompanyId = $("#subCompanyId").val(),
            	type = $that.data("type"),
            	auditType = $("#auditType").val(),
            	id = $that.data("id");
        	var url = "/vst_admin/o2o/subCompany/showContractForm.do?subCompanyId="+subCompanyId+"&type="+type+"&auditType="+auditType+"&id="+id;
            dialogContractInfoDetail = backstage.dialog({
                width: 760,
                height: 450,
                title: "合同签署备案信息",
                iframe: true,
                url: url
            });
        }

        //查看合同签署备案信息
        $document.on("click", ".JS_view_ci", editContractInfoHanlder);

        // 删除操作
        $document.on("click", ".JS_del_ci", delContractInfoHanlder);
        function delContractInfoHanlder() {
            var $that = $(this),
            	subCompanyId = $("#subCompanyId").val(),
            	id = $that.data("id");
        	var loading = backstage.loading({
			    title: "系统提醒消息",
			    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
			});
        	var dialogDelete = backstage.confirm({
                content: "确认删除？",
                determineCallback: function() {
                	$.ajax({
						url : "/vst_admin/o2o/subCompany/contract/remove.do",
						type : 'post',
						data : "id="+id+"&subCompanyId="+subCompanyId,
						success : function(result) {
							loading.destroy();
							if(result.code == "success"){
						   		backstage.alert({
						   			content: result.message,
						   			callback: function(){
						   				$("#subco_contract", window.parent.document).parent("li").click();
						   			}
					   			});
							}
						},
						error : function(result){
							backstage.alert({
					   			content: result,
					   			callback: function () {
					   				loading.destroy();
					   			}
				   			});
						}
				  	})
                },
                cancelCallback: function(){
					loading.destroy();
				}
            });
        }

        //编辑合同附件
        $document.on("click", ".JS_edit_ca", contractAttachmentHanlder);

        //查看合同附件
        $document.on("click", ".JS_view_ca", contractAttachmentHanlder);
        function contractAttachmentHanlder() {
            var $this = $(this),
            	param = {},
            	auditType = $("#auditType").val(),
            	type = $this.data("type"),
            	contractId = $this.data("id"),
            	subCompanyId = $("#subCompanyId").val();
        	param.subCompanyId = subCompanyId;
        	param.type =type;
        	param.contractId = contractId;
            var url = "/vst_admin/o2o/subCompany/contract/scans.do?param="+ JSON.stringify(param) + "&auditType=" + auditType +"&_="+new Date();;
            var dialogContractAttachment = backstage.dialog({
                width: 720,
                height: 450,
                title: "合同附件",
                iframe: true,
                url: url
            });
            window.dialogContractAttachment = dialogContractAttachment;
        }

    });
    </script>
</body>

</html>

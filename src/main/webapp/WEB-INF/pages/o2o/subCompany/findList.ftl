<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>O2O子公司管理</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css"/>
</head>
<body class="o2o-manage">

<div class="everything">
    <!--筛选 开始-->
    <div class="filter">
        <form class="filter-form clearfix" action='/vst_admin/o2o/subCompanys.do' id="searchSubCompanyForm" method="post">
            <div class="col w800">
                <div class="row">
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block text-right">子公司</span>
                                <input name="name" class="form-control w90" type="text" <#if subCompany??>value="${subCompany.name!''}"</#if>/>
                            </label>
                        </div>
                    </div>
                    <@mis.checkPerm permCode="5120,5121" permParentCode="5116">
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block text-right">地区</span>
                                <input name="companyLocation" class="form-control w90" type="text" <#if subCompany??>value="${subCompany.companyLocation!''}"</#if> />
                            </label>
                        </div>
                    </div>
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block text-right">子公司状态</span>
                                <select class="form-control w90" name="coStatus">
                   					<option value="">全部</option>
			                    	<option value='Y'<#if subCompany?? && subCompany.coStatus == 'Y'>selected</#if>>有效</option>
			                    	<option value='N'<#if subCompany?? && subCompany.coStatus == 'N'>selected</#if>>无效</option>
	                            </select>
                            </label>
                        </div>
                    </div>
                    <input name="writablePerm" type="hidden" value="true"/>
                    </@mis.checkPerm >
                    <div class="col w180">
                        <div class="form-group">
                            <label>
                                <span class="w60 inline-block text-right">子公司</span>
                                <select name="auditStatus" class="form-control w100">
        	 						<option value="">全部</option>
			    					<#list auditTypes as list>
			                    		<option value=${list.code!''} <#if subCompany?? && subCompany.auditStatus==list.code>selected</#if> >${list.cnName!''}</option>
				                	</#list>
				        		</select>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pull-right">
                <div class="btn-group">
                    <a class="btn btn-primary" id="search_button">查询</a>
                    <@mis.checkPerm permCode="5120">
                    	<a class="btn JS_add" id="new_subCompany">新增</a>
                    </@mis.checkPerm >
                </div>
            </div>
        </form>
    </div>
    <!--筛选 结束-->
    <div class="si-table">
        <#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
	        <table class="table table-border table_center">
	            <thead>
	            <tr>
	                <th width="70">序号</th>
	                <th width="200">子公司名称</th>
	                <th width="100">地区</th>
	                <th width="160">管辖区域</th>
	                <th width="70">门店数</th>
	                <th width="100">子公司状态</th>
	                <th width="100">审核状态</th>
	                <th width="200">操作</th>
	            </tr>
	            </thead>
	            <tbody>
	            <#list pageParam.items as subCompany>
		            <tr>
		                <td>
							${subCompany.id!''}
							<#if subCompany?? && subCompany.auditStatus=='SUBMITTED' && !subCompany.approveTime?exists>
		                		<i class="icon icon-warning"></i> 
		                	</#if>
						</td>
		                <td>
		                    <div class="w200 text-ellipsis">
		                        ${subCompany.name!''}
		                    </div>
		                </td>
		                <td><div class="w200 text-ellipsis">
		                        ${subCompany.companyLocation!''}
		                    </div>
	                    </td>
		                <td>
		                	<div class="w160 text-ellipsis">
		                        ${subCompany.manageArea!''}
		                    </div>
	                	</td>
		                <td>${subCompany.posNumber!''}</td>
		                <td>
		                	<#if subCompany.coStatus == "Y">
			               		<span class="text-success">有效
			                <#else>
			                	<span class="text-danger">无效</span>
			                </#if>
	                	</td>
		                <td>
							<#if subCompany.auditStatus??>
								<#list auditTypes as audit>
				            			 <#if subCompany?? && subCompany.auditStatus==audit.code>${audit.cnName}</#if>
				            	</#list>
			            	</#if>
						</td>
		                <td>
		                    <@mis.checkPerm permCode="5119">
		                		<#if subCompany?? && subCompany.approveTime??>
		                    		<a href="javascript:void(0);" class="mr5 JS_view_subCompany" data-audit="${subCompany.auditStatus!''}" data-id="${subCompany.id}" data-type="READONLY">查看</a>
		                    	</#if>
		                    </@mis.checkPerm >
		                	<#if subCompany?? && subCompany.auditStatus!='SUBMITTED'>
			                    <@mis.checkPerm permCode="5120">
		                    		<a href="javascript:void(0);" class="mr5 JS_update_subCompany" data-audit="${subCompany.auditStatus!''}" data-id="${subCompany.id}" data-type="WRITABLE">编辑</a>
			                    </@mis.checkPerm >
		                    </#if>
		                    <#if subCompany?? && subCompany.auditStatus=='SUBMITTED'>
			                    <@mis.checkPerm permCode="5121">
		                    		<a href="javascript:void(0);" class="mr5 JS_audit_subCompany" data-id="${subCompany.id}">审核</a>
			                    </@mis.checkPerm >
			                    <@mis.checkPerm permCode="5120">
		                    		<a href="javascript:void(0);" class="mr5 JS_cancel_audit_subCompany" data-id="${subCompany.id}">撤销审核</a>
			                    </@mis.checkPerm >
			                    <@mis.checkPerm permCode="5121">
		                    		<a href="javascript:void(0);" class="mr5 JS_subCompany_comparison" data-audit="${subCompany.auditStatus!''}" data-id="${subCompany.id}" data-type="COMPARED">审核内容</a>
			                    </@mis.checkPerm >
		                	</#if>
		                	<#if subCompany?? && subCompany.auditStatus=='NOT_SUBMIT'>
			                    <@mis.checkPerm permCode="5120">
		                    		<a href="javascript:void(0);" class="mr5 JS_submit_audit_subCompany" data-id="${subCompany.id}">提交审核</a>
				                </@mis.checkPerm >
		                	</#if>
		                    <@mis.checkPerm permCode="5120,5121" permParentCode="5116">
		                    	<a href="javascript:void(0);" class="mr5 JS_operate_log" data-param="{'parentId':${subCompany.id},'parentType':'SUB_CO'}">操作日志</a>
		                    </@mis.checkPerm >
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
	            <span class="icon icon-big icon-info"></span>
	            抱歉，查询暂无数据
	        </div>
        </#if>
    </div>
</div>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script>

    var auditFormDialog,
        searchHandler;
    $(function () {
        var $document = $(document);

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>

        searchHandler = function () {
			$("input[name=name]").val( $.trim($("input[name=name]").val()));
	        <@mis.checkPerm permCode="5120,5121" permParentCode="5116">
				$("input[name='companyLocation']").val($.trim($("input[name='companyLocation']").val()));
				$("input[name='coStatus']").val($.trim($("input[name='coStatus']").val()));
			</@mis.checkPerm >
			$("#searchSubCompanyForm").submit();
        }
        // 查询子公司信息列表
        $document.on("click", "#search_button", searchHandler);

        //新增子公司
        $document.on("click", "#new_subCompany", addSubCompanyHanlder);
        function addSubCompanyHanlder() {
			window.open("/vst_admin/o2o/subCompany/showMaintain.do");
        }

		var eventHandler = function(){
			var $that = $(this),
        		id = $that.data("id"),
        		type = $that.data("type"),
        		audit = $that.data("audit");
			window.open("/vst_admin/o2o/subCompany/showMaintain.do?subCompanyId=" + id + "&type=" + type);
		}

        // 查看子公司信息
        $("a.JS_view_subCompany").bind("click",eventHandler);

        // 编辑子公司信息
        $("a.JS_update_subCompany").bind("click",eventHandler);

		var submitOrCancelAudit = function (msg, data) {
			var loading = backstage.loading({
			    title: "系统提醒消息",
			    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
			});
			backstage.confirm({
				content: msg,
				determineCallback: function(){
					$.ajax({
						url : "/vst_admin/o2o/subCompany/audit.do",
						type : 'post',
						dataType : 'json',
						data : data,
						success : function(result) {
							loading.destroy();
							if(result.code == "success"){
								backstage.alert({
									content : result.message, 
									callback : searchHandler
								});
							}else {
								backstage.alert({
									content : result.message
								});
							}
						},
						error : function(result){
							backstage.alert({
								content : result,
								callback: function (){
									loading.destroy();
								}
							});
						}
					  })
				},
				cancelCallback:function(){
					loading.destroy();
				}
			});
		}

        // 提交审核子公司信息
        $("a.JS_submit_audit_subCompany").bind("click",function(){
			var id=$(this).data("id");
			submitOrCancelAudit("是否提交审核？", {"id": id, "auditStatus": "SUBMITTED"});
		});

        // 审核子公司信息
        $document.on("click", ".JS_audit_subCompany", viewSubCompanyHanlder);
        function viewSubCompanyHanlder() {
			var id=$(this).data("id");
			var url = "/vst_admin/o2o/subCompany/showAduitDialog.do?id="+id;
            auditFormDialog = backstage.dialog({
                width: 800,
                height: 400,
                title: "提交审核结果",
                iframe: true,
                url: url
            });
        }
        // 撤销审核子公司信息
        $("a.JS_cancel_audit_subCompany").bind("click",function(){
			var id=$(this).data("id");
			submitOrCancelAudit("是否撤销审核？", {"id": id, "auditStatus": "NOT_SUBMIT"});
		});

        // 审核子公司信息内容
        $("a.JS_subCompany_comparison").bind("click",eventHandler);

        // 操作日志
        $("a.JS_operate_log").bind("click",function(){
			var param=$(this).data("param");
			var url = "/vst_admin/o2o/findOperateLogs.do?param="+param;
            backstage.dialog({
                width: 1000,
                height: 600,
                title: "日志详情页",
                iframe: true,
                url: url
            });
		});
    });

</script>
</body>
</html>

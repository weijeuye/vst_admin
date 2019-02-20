<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>合作股东关联公司</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subCompany/shareholder-info.css"/>
</head>
<body class="associate-company-list">
    <div class="everything">
        <!--筛选 开始-->
        <div class="filter">
            <form id="sholdAssCompany" class="filter-form clearfix" method="post" action="/vst_admin/o2o/sholdAssCompanys.do">
                <div class="col w800">
                    <div class="row">
                        <div class="col w220">
                            <div class="form-group">
                                <label>
                                    <span class="w100 inline-block text-right">股东方关联公司</span>
                                    <input class="form-control w100" type="text" name="name" <#if sholdAssCompany??>value="${sholdAssCompany.name!''}"</#if> />
                                </label>
                            </div>
                        </div>
                        <@mis.checkPerm permCode="5123,5124" permParentCode="5117">
	                        <div class="col w160">
	                            <div class="form-group">
	                                <label>
	                                    <span class="w40 inline-block text-right">股东</span>
	                                    <input class="form-control w100" type="text" name="sholdName" <#if sholdAssCompany??>value="${sholdAssCompany.sholdName!''}"</#if> />
	                                </label>
	                            </div>
	                        </div>
	                        <div class="col w200">
	                            <div class="form-group">
	                                <label>
	                                    <span class="w80 inline-block text-right">关联公司状态</span>
	                                    <select class="form-control w100" name="assoStatus">
		                   					<option value="">全部</option>
					                    	<option value='Y'<#if sholdAssCompany?? && sholdAssCompany.assoStatus == 'Y'>selected</#if>>有效</option>
					                    	<option value='N'<#if sholdAssCompany?? && sholdAssCompany.assoStatus == 'N'>selected</#if>>无效</option>
			                            </select>
	                                </label>
	                            </div>
	                        </div>
	                        <input name="writablePerm" type="hidden" value="true"/>
                    	</@mis.checkPerm >
                        <div class="col w180">
                            <div class="form-group">
                                <label>
                                    <span class="w60 inline-block text-right">审核状态</span>
                                    <select name="auditStatus" class="form-control w100">
	        	 						<option value="">全部</option>
				    					<#list auditTypes as list>
				                    		<option value=${list.code!''} <#if sholdAssCompany?? && sholdAssCompany.auditStatus==list.code>selected</#if> >${list.cnName!''}</option>
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
                        <@mis.checkPerm permCode="5123">
                        	<a class="btn" id="new_AssCompany">新增</a>
                        </@mis.checkPerm >
                    </div>
                </div>
            </form>
        </div>
        <!--筛选 结束-->

        <div class="si-table">
            <#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
	            <table class="table table-border">
	                <thead>
	                <tr>
	                    <th width="60">序号</th>
	                    <th width="150">股东方</th>
	                    <th width="150">股东方关联公司</th>
	                    <th width="80">第一负责人</th>
	                    <th width="100">手机</th>
	                    <th width="110">关联公司状态</th>
	                    <th width="110">审核状态</th>
	                    <th width="240">操作</th>
	                </tr>
	                </thead>
	                <tbody>
	                <#list pageParam.items as item>
	                <tr>
	                    <td>
							${item.id!''}
							<#if item?? && item.auditStatus=='SUBMITTED' && !item.approveTime?exists>
		                		<i class="icon icon-warning"></i> 
		                	</#if>
						</td>
	                    <td>
	                        <div class="w150 text-ellipsis">
	                     		${item.shareholdersName!''}
	                        </div>
	                    </td>
	                    <td>
	                        <div class="w150 text-ellipsis">
	                           ${item.name!''}
	                        </div>
	                    </td>
	                    <td>${item.principalName!''}</td>
	                    <td>
	                        <div class="w100 text-ellipsis">
	                            ${item.mobile!''}
	                        </div>
	                    </td>
	                    <td>
	                        <#if item.assoStatus == "Y">
			               		<span class="text-success">有效
			                <#else>
			                	<span class="text-danger">无效</span>
			                </#if>
	                    </td>
	                    <td>
	                        <#if item.auditStatus??>
								<#list auditTypes as audit>
			            			<#if item?? && item.auditStatus==audit.code>${audit.cnName}</#if>
				            	</#list>
			            	</#if>
	                    </td>
	                    <td>
	                    	<@mis.checkPerm permCode="5122">
		                		<#if item?? && item.approveTime??>
		                    		<a href="javascript:void(0);" class="mr5 JS_view_sholdAssCompany" data-audit="${item.auditStatus!''}" data-id="${item.id}" data-type="READONLY">查看</a>
		                    	</#if>
		                    </@mis.checkPerm >
		                	<#if item?? && item.auditStatus!='SUBMITTED'>
			                    <@mis.checkPerm permCode="5123">
		                    		<a href="javascript:void(0);" class="mr5 JS_update_sholdAssCompany" data-audit="${item.auditStatus!''}" data-id="${item.id}" data-type="WRITABLE">编辑</a>
			                    </@mis.checkPerm >
		                    </#if>
		                    <#if item?? && item.auditStatus=='SUBMITTED'>
			                    <@mis.checkPerm permCode="5124">
		                    		<a href="javascript:void(0);" class="mr5 JS_audit_sholdAssCompany" data-id="${item.id}">审核</a>
			                    </@mis.checkPerm >
			                    <@mis.checkPerm permCode="5123">
		                    		<a href="javascript:void(0);" class="mr5 JS_cancel_audit_sholdAssCompany" data-id="${item.id}">撤销审核</a>
			                    </@mis.checkPerm >
			                    <@mis.checkPerm permCode="5124">
		                    		<a href="javascript:void(0);" class="mr5 JS_sholdAssCompany_comparison" data-audit="${item.auditStatus!''}" data-id="${item.id}" data-type="COMPARED">审核内容</a>
			                    </@mis.checkPerm >
		                	</#if>
		                	<#if item?? && item.auditStatus=='NOT_SUBMIT'>
			                    <@mis.checkPerm permCode="5123">
		                    		<a href="javascript:void(0);" class="mr5 JS_submit_audit_sholdAssCompany" data-id="${item.id}">提交审核</a>
				                </@mis.checkPerm >
		                	</#if>
		                    <@mis.checkPerm permCode="5123,5124" permParentCode="5117">
		                    	<a href="javascript:void(0);" class="mr5 JS_operate_log" data-param="{'parentId':${item.id},'parentType':'ASSCO_CO'}">操作日志</a>
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
	        <@mis.checkPerm permCode="5123,5124" permParentCode="5117">
	        	$("input[name=sholdName]").val( $.trim($("input[name=sholdName]").val()));
	        	$("input[name=assoStatus]").val( $.trim($("input[name=assoStatus]").val()));
			</@mis.checkPerm >
			$("#sholdAssCompany").submit();
        }
        // 查询股东关联公司信息列表
        $document.on("click", "#search_button", searchHandler);

        //新增股东关联公司
        $document.on("click", "#new_AssCompany", addSholdAssCompanyHanlder);
        function addSholdAssCompanyHanlder() {
			window.open("/vst_admin/o2o/sholdAssCompany/showMaintain.do");
        }

		var eventHandler = function(){
			var $that = $(this),
        		id = $that.data("id"),
        		type = $that.data("type"),
        		audit = $that.data("audit");
			window.open("/vst_admin/o2o/sholdAssCompany/showMaintain.do?companyId=" + id + "&type=" + type);
		}

        // 查看股东关联公司信息
        $("a.JS_view_sholdAssCompany").bind("click",eventHandler);

        // 编辑股东关联公司信息
        $("a.JS_update_sholdAssCompany").bind("click",eventHandler);

		var submitOrCancelAudit = function (msg, data) {
			var loading = backstage.loading({
				    title: "系统提醒消息",
				    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
				});
			backstage.confirm({
				content: msg,
				determineCallback: function(){
					$.ajax({
						url : "/vst_admin/o2o/sholdAssCompany/audit.do",
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
								callback: function() {
									loading.destroy();
								}
							});
						}
					  })
				},
				cancelCallback: function () {
					loading.destroy();
				}
			});
		}

        // 提交审核股东关联公司信息
        $("a.JS_submit_audit_sholdAssCompany").bind("click",function(){
			var id=$(this).data("id");
			submitOrCancelAudit("是否提交审核？", {"id": id, "auditStatus": "SUBMITTED"});
		});

        // 审核股东关联公司信息
        $document.on("click", ".JS_audit_sholdAssCompany", viewSholdAssCompanyHanlder);
        function viewSholdAssCompanyHanlder() {
			var id=$(this).data("id");
			var url = "/vst_admin/o2o/sholdAssCompany/showAduitDialog.do?id="+id;
            auditFormDialog = backstage.dialog({
                width: 800,
                height: 400,
                title: "提交审核结果",
                iframe: true,
                url: url
            });
        }
        // 撤销审核股东关联公司信息
        $("a.JS_cancel_audit_sholdAssCompany").bind("click",function(){
			var id=$(this).data("id");
			submitOrCancelAudit("是否撤销审核？", {"id": id, "auditStatus": "NOT_SUBMIT"});
		});

        // 审核股东关联公司信息内容
        $("a.JS_sholdAssCompany_comparison").bind("click",eventHandler);

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

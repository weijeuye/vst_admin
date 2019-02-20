<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>营业网点</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
	<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/edit-shareholder.css" />
</head>

<body class="contract-info my-body">
    <p class="main-title">营业网点</p>
    <div class="row">
    	<div class="col w15"></div>
    	<#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
    		<@mis.checkPerm permCode="5120">
	    		<a class="btn JS_add_bn">新增</a>
	    	</@mis.checkPerm >
		</#if>
	</div>
    <div class="main">
    	<input type="hidden" id="subCompanyId" <#if subCompanyId??>value=${subCompanyId}</#if> />
    	<input type="hidden" id="viewType" name="type" value="${type!''}">
		<input type="hidden" id="auditType" name="auditType" value="${auditType!''}">
        <div>
	        <#if pageParam?? && pageParam.items?? &&  pageParam.items?size &gt; 0>
	            <table class="table table-border table_center">
	                <thead>
	                    <tr>
	                        <th width="95">序号</th>
	                        <th width="80">所在地</th>
	                        <th width="80">营业网点名称</th>
	                        <th width="110">分公司/营业许可证号</th>
	                        <th width="60">网点类型</th>
	                        <th width="110">经营地址</th>
	                        <th width="50">店长姓名</th>
	                        <th width="90">手机</th>
	                        <th width="220">操作</th>
	                    </tr>
	                </thead>
	                <tbody>
	                <#list pageParam.items as pos>
	                    <tr>
	                    	<td>
	                        	${pos.id!''}
								<#if type?upper_case=="COMPARED" && pos?? && auditType?upper_case=='SUBMITTED'>
									<#if !pos.approveTime??>
				                		<i class="icon icon-warning"></i> 
			                		<#elseif pos?? && pos.delForCompared == 'Y'>
			                			<i class="icon icon-danger"></i>
				                	</#if>
			                	</#if>
	                    	</td>
	                        <td>
	                        	<div class="w80 text-ellipsis">
			                        ${pos.salesLocation!''}
			                    </div>
	                        </td>
	                        <td>${pos.name!''}</td>
	                        <td>
	                            <div class="w110 text-ellipsis">${pos.posPermitNo!''}</div>
	                        </td>
	                        <td>${pos.posPermitNo!''}</td>
	                        <td>
	                            <div class="w110 text-ellipsis">${pos.businessAddress!''}</div>
	                        </td>
	                        <td>${pos.posManagerName!''}</td>
	                        <td>${pos.mobile!''}</td>
	                        <td>
	                        	<#if type?upper_case=="COMPARED">
	                            	<@mis.checkPerm permCode="5121">
		                            	<a class="mr5 JS_view_bn" data-type="COMPARED" data-id="${pos.id}">查看</a>
		                            	<a class="mr5 JS_view_ca" data-type="COMPARED" data-objecttype="POINT_OF_SALES" data-id="${pos.id}">查看合同</a>
	                            	</@mis.checkPerm >
                            	<#elseif type?upper_case!='COMPARED' && pos?? && pos.approveTime??>
                            		<@mis.checkPerm permCode="5119">
	                            		<a class="mr5 JS_view_bn" data-type="READONLY" data-id="${pos.id}">查看</a>
	                            		<a class="mr5 JS_view_ca" data-type="READONLY" data-objecttype="POINT_OF_SALES" data-id="${pos.id}">查看合同</a>
                        			</@mis.checkPerm >
	                            </#if>
	                            <#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
	                            	<@mis.checkPerm permCode="5120">
			                            <a class="mr5 JS_edit_bn" data-type="WRITABLE" data-id="${pos.id}">编辑</a>
			                            <a class="mr5 JS_edit_ca" data-type="WRITABLE" data-objecttype="POINT_OF_SALES" data-id="${pos.id}">编辑材料</a>
			                            <a class="mr5 JS_del_bn" data-id="${pos.id}">删除</a>
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
    var posDialog;
    $(function() {

        var $document = $(document);

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>

        //新增营业网点
        $document.on("click", ".JS_add_bn", addBusinessNetworkHanlder);
        function addBusinessNetworkHanlder() {
            var $this = $(this),
            	subCompanyId = $("#subCompanyId").val(),
            	type = $("#viewType").val(),
            	auditType = $("#auditType").val();
        	var url = "/vst_admin/o2o/subCompany/showPOSForm.do?subCompanyId="+subCompanyId+"&type="+type+"&auditType="+auditType;
            posDialog = backstage.dialog({
                width: 720,
                height: 640,
                title: "新增营业网点",
                iframe: true,
                url: url
            });
        }

        //编辑营业网点
        $document.on("click", ".JS_edit_bn", editBusinessNetworkHanlder);
        function editBusinessNetworkHanlder() {
            var $this = $(this),
            	subCompanyId = $("#subCompanyId").val(),
            	type = $this.data("type"),
            	auditType = $("#auditType").val(),
            	id = $this.data("id");
            var url = "/vst_admin/o2o/subCompany/showPOSForm.do?subCompanyId="+subCompanyId+"&type="+type+"&auditType="+auditType+"&id="+id;
            posDialog = backstage.dialog({
                width: 720,
                height: 640,
                title: "编辑营业网点",
                iframe: true,
                url: url
            });
        }

        //查看营业网点
        $document.on("click", ".JS_view_bn", editBusinessNetworkHanlder);

        // 删除操作
        $document.on("click", ".JS_del_bn", delBusinessNetworkHanlder);
        function delBusinessNetworkHanlder() {
            var $this = $(this),
            	subCompanyId = $("#subCompanyId").val(),
            	id = $this.data("id");
            var loading = backstage.loading({
			    title: "系统提醒消息",
			    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
			});
            var dialogDelete = backstage.confirm({
                content: "确认删除？",
                determineCallback: function() {
                    $.ajax({
						url : "/vst_admin/o2o/subCompany/pos/remove.do",
						type : 'post',
						data : "id="+id+"&subCompanyId="+subCompanyId,
						success : function(result) {
							loading.destroy();
							if(result.code == "success"){
						   		backstage.alert({
						   			content: result.message,
						   			callback: function(){
						   				$("#subco_pos", window.parent.document).parent("li").click();
						   			}
					   			});
							}
						},
						error : function(){
							backstage.alert({
					   			content: "系统异常",
					   			callback: function () {
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

        //编辑证照材料
        $document.on("click", ".JS_edit_ca", contractAttachmentHanlder);

        //查看证照材料
        $document.on("click", ".JS_view_ca", contractAttachmentHanlder);
        function contractAttachmentHanlder() {
            var $this = $(this),
            	param = {},
            	auditType = $("#auditType").val(),
            	type = $this.data("type"),
            	objectType = $this.data("objecttype"),
            	objectId = $this.data("id"),
            	subCompanyId = $("#subCompanyId").val();
        	param.objectType = objectType;
			param.objectId = objectId;
			param.subCompanyId = subCompanyId;
			param.type = type;
			param.dataRefer = "SUB_CO";
            var url = "/vst_admin/o2o/showMaterials.do?param="+ JSON.stringify(param) + "&auditType=" + auditType +"&_="+new Date();;
            var posMaterialsDialog = backstage.dialog({
                width: 720,
                height: 450,
                title: "合同附件",
                iframe: true,
                url: url
            });
            window.posMaterialsDialog = posMaterialsDialog;
        }


    });
    </script>
</body>

</html>

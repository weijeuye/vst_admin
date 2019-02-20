<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑合同附件</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>
<body class="edit-contract-attachment my-body">
	<div class="main">
        <form action="/vst_admin/o2o/subCompany/contract/scans.do" id="contractScanForm" name="contractScanForm" method="POST" enctype="multipart/form-data">
        	<input name="contractId" type="hidden" value="${contractId}"/>
        	<input name="serverType" type="hidden" value="COM_AFFIX"/>
        	<input name="subCompanyId" type="hidden" value="${subCompanyId}"/>
        	<input name="delIds" type="hidden"/>
            <dl class="clearfix">
                <dt>
                    <label for="">
                        证照材料：
                    </label>
                </dt>
                <dd class="contracts_dd" data-type="scan">
                	<#-- 如果是审核内容则先显示被删除的 -->
               		<#if type?upper_case == 'COMPARED'>
	                    <#list oldScanList as item>
	                    	<#if !scanIds?seq_contains(item.id)>
			                    <div class="files-uploaded">
			                        <div class="file-input-group clearfix">
		                            	<i class="icon icon-danger"></i>
			                            <a class="w200 fg-link-name" href="/vst_admin/pet/ajax/file/downLoad.do?fileId=${item.fileId}" title="${item.name} ${item.createTime?string('yyyy-MM-dd')}">${item.name}</a>
			                        </div>
			                    </div>
	                    	</#if>
	                	</#list>
                	</#if>
                    <#list scanList as item>
	                    <div class="files-uploaded">
	                        <div class="file-input-group clearfix">
	                            <#if type?upper_case == 'COMPARED'>
	                            	<#if !item.approveTime??>
		                            	<i class="icon icon-warning"></i>
		                            </#if>
	                            </#if>
	                            <a class="w200 fg-link-name" href="/vst_admin/pet/ajax/file/downLoad.do?fileId=${item.fileId}" title="${item.name} ${item.createTime?string('yyyy-MM-dd')}">${item.name}</a>
	                            <#if type?upper_case == 'WRITABLE'>
	                            	<a class="btn fg-del-btn JS_del_uploaded_file" data-param=${item.id}>删除</a>
	                            </#if>
	                        </div>
	                    </div>
                	</#list>
                	<#if type?upper_case == 'WRITABLE'>
	                    <div class="file-input-group clearfix">
	                        <input name="" type="text" class="form-control w200 fg-name"/>
	                        <a class="btn fg-del-btn">删除</a>
	                        <a class="btn btn-primary fg-upload-btn">点击上传</a>
	                        <input name="scan" type="file" multiple class="w310 fg-file-input" accept=".doc,.docx,.xls,.xlsx,.pdf,.jpg,.jpeg,.png" />
	                    </div>
                    </#if>
                </dd>
            <#if type?upper_case == 'WRITABLE'>
	            <p class="upload-warn-text">
	                注：上传格式为：word、excel、pdf、jpg、jpeg、png文件
	            </p>
            </#if>
        </form>
    </div>
    <!--模板 开始-->
    <div class="template">
        <div class="file-input-group clearfix">
            <input name="" type="text" class="form-control w200 fg-name" />
            <a class="btn fg-del-btn">删除</a>
            <a class="btn btn-primary fg-upload-btn">点击上传</a>
            <input name="" type="file" class="w310 fg-file-input" multiple accept=".doc,.docx,.xls,.xlsx,.pdf,.jpg,.jpeg,.png" />
        </div>
    </div>
    <div class="btn-group text-center">
    	<#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
    		<a class="btn btn-primary JS_btn_save">保存</a>
		</#if>
    </div>
    <!--模板 结束-->
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/base.js"></script>
    <script>
    $(function() {

        var $document = $(document);
        var $template = $(".template"),
        	delIds = [],
        	changeFlag = 0;

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>

        // 添加合同
        $document.on('change', '.fg-file-input', function() {
            var $this = $(this);
            var $group = $this.parent('.file-input-group');
            var $contractsDd = $this.parents(".contracts_dd");
            $this.hide();
            $group.find('.fg-upload-btn').hide();
            $group.find('.fg-del-btn').show();
            var path = $this.val();
            var name = path.substring(path.lastIndexOf("\\") + 1);
            $group.find('.fg-name').val(name);

            var $tem = $template.find('.file-input-group').clone();
            $tem.find('.fg-file-input').attr('name',$contractsDd.data("type"));
            $contractsDd.append($tem);
            changeFlag += 1;
        });

        // 删除之前已有的文件
        $document.on('click', '.fg-del-btn', function() {
            var param = $(this).data("param");
            if(!!param) {
	            delIds.push(param);
            } else {
            	changeFlag = changeFlag - 1;
            }
        });

		$document.on("click", ".JS_btn_save", function() {
        	$(".JS_btn_save").hide();
        	var loading = backstage.loading({
			    title: "系统提醒消息",
			    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
			});
		 	var data = new FormData(document.forms.namedItem("contractScanForm"));
		 	if(delIds.length > 0) {
		 		data.append("delIds[]", delIds);
		 	}
			if(delIds.length == 0 && changeFlag <= 0) {
		 		backstage.alert({
	   		  		content: "您未做任何改动。",
	   		  		callback: function () {
	   		  			$(".JS_btn_save").show();
	   		  			loading.destroy();
	   		  		}
	   		  	});
	   		  	return;
		 	}
            backstage.confirm({
            	content: "确认提交吗 ？",
            	determineCallback: function () {
					$.ajax({
					   url : "/vst_admin/o2o/subCompany/contract/scan.do",
					   processData: false,
					   contentType: false,
					   type:"POST",
					   data:data,
					   success : function(result){
					   		loading.destroy();
						   	if(result.code=="success"){
						   		backstage.alert({
						   			content: result.message,
						   			callback: function () {
							   			$(".JS_btn_save").show();
							   			window.parent.dialogContractAttachment.destroy();
						   			}
						   		});
						   	}else {
					   		  	backstage.alert({
					   		  		content: result.message,
					   		  		callback: function () {
					   		  			$(".JS_btn_save").show();
					   		  		}
					   		  	});
					   		}
					   },
						error : function(){
							backstage.alert({
				   		  		content: "系统异常",
				   		  		callback: function () {
									loading.destroy();
									$(".JS_btn_save").show();
				   		  		}
				   		  	});
						}
					  })
				},
				cancelCallback: function(){
					loading.destroy();
					$(".JS_btn_save").show();
				}
			});
        });
    });
    </script>
</body>

</html>

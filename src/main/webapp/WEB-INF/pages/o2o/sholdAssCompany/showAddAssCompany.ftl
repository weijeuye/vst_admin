<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑基本信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="edit-basic-info my-body">
    <div class="main">
        <form id="assoCompanyForm">
            <p class="main-title">基本信息</p>
            <dl class="clearfix">
                <dt>
                    <label for="">
                        关联公司名：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="name" maxlength="90" data-validate="{required:true}" type="text" class="form-control w200"/>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        旅行社许可证号：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="permitNo" maxlength="50" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        第一负责人：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="principalName" maxlength="25" type="text" class="form-control w200"/>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        手机：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="mobile" maxlength="25" type="text" class="form-control w200"/>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        QQ号：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="qq" maxlength="25" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        邮箱：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="mail" maxlength="40" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        电话：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="tel" maxlength="25" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        传真：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="fax" maxlength="25" type="text" class="form-control w200" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        关联公司状态：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                    	<select class="form-control w200" name="assoStatus">
		                    	<option value='Y'>有效</option>
		                    	<option value='N'>无效</option>
                        </select>
                    </div>
                </dd>
            </dl>
            <div class="btn-group text-center">
            	<@mis.checkPerm permCode="5123">
                	<a class="btn btn-primary JS_btn_save">保存</a>
            	</@mis.checkPerm >
            </div>
        </form>
    </div>

    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/base.js"></script>
    <script>
    $(function() {

        var $document = $(document);
        var $template = $(".template");

        // 表单验证
        var $form = $(".main").find("form");
        var validateAdd = backstage.validate({
            $area: $form,
            REQUIRED: "不能为空",
            showError: true
        });
        validateAdd.watch();

        $document.on("click", ".JS_btn_save", function() {
            validateAdd.refresh();
            validateAdd.watch();
            validateAdd.test();
            if (validateAdd.getIsValidate()) {
                $(".JS_btn_save").hide();
            	var loading = backstage.loading({
				    title: "系统提醒消息",
				    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
				});
                backstage.confirm({
                	content: "确定要保存么？",
                	determineCallback: function(){
						$.ajax({
							url : "/vst_admin/o2o/sholdAssCompany.do",
							type : "post",
							dataType : 'json',
							data : $("#assoCompanyForm").serialize(),
							success : function(result) {
								loading.destroy();
								if(result.code == "success"){
									backstage.alert({
						   		  		content: result.message,
						   		  		callback: function () {
											//为父窗口设置productId
											$("#companyId",window.parent.document).val(result.attributes.companyId);
											$("#viewType",window.parent.document).val("WRITABLE");
						   		  			$("#asso_co_base", window.parent.document).parent("li").click();
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
								loading.destroy();
								$(".JS_btn_save").show();
							}
						  })
					},
					cancelCallback: function(){
						loading.destroy();
						$(".JS_btn_save").show();
					}
				});
            }
        });

    });
    </script>
</body>

</html>

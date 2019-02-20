/**
*vst_pet工具类
*@author ranlongfei
*@date 2013-11-20
*/

var vst_pet_util = {
		/**
		 * 系统用户类
		 * @param showNode 显示姓名的控件
		 * @param idNode 保存ID的控件，一般是个隐藏域
		 */
		superUserSuggest : function(showNode, idNode) {
			$(showNode).jsonSuggest({
				url : "/vst_admin/pet/permUser/searchUser.do",
				maxResults : 10,
				minCharacters : 1,
				onSelect : function(item) {
					$(idNode).val(item.id);
				}
			});
			//如果没有选中则清空内容
			if(idNode!=null&&idNode!=""&&$(idNode).size()>0){
				$(showNode).live('blur',function(){
					var idNodeValue = $(idNode).val();
					var length = idNodeValue.length;
					if(length<=0){
						$(this).val('');
					}
				});
			}
		},
	/**
	 * 系统用户类
	 * @param showNode 显示姓名的控件
	 * @param idNode 保存ID的控件，一般是个隐藏域
	 */
	superUserSuggestAdvance : function(showNode,callBack) {
		$(showNode).jsonSuggest({
			url : "/vst_admin/pet/permUser/searchUser.do",
			maxResults : 10,
			minCharacters : 1,
			onSelect : function(item) {
				if(callBack)
				callBack(item);
			}
		});
	},
		
	       /**
	        * 目的地名称列表
	        * @param showNode
	        * @param idNode
	        * @param _flag 是否需要选中
	        */
	       destListSuggest : function(showNode, idNode, _flag) {
	    	    
				$(showNode).jsonSuggest({
					url : "/vst_admin/biz/dest/searchDestList.do",
					//maxResults : 10,
					minCharacters : 1,
					flag:_flag,
					onSelect :  function(item) {
						$(idNode).val(item.id);
					}
				});
			},
			
			 /**
		        * 可换酒店名称列表
		        * @param showNode
		        * @param districtName 行政区划名称
		        */
		       changeHotelListSuggest : function(showNode, districtName) {
		    	   $(showNode).jsonSuggest({
						url : "/vst_admin/biz/changeHotel/searchChangeHotelList.do?districtName="+districtName,
						minCharacters : 1,
						onSelect : function(item) {
							fillHotelData(item.id);
						}
					});
				},

       
		/**
		 * 通用列表补全查询
		 * @param showNode 显示姓名的控件
		 * @param idNode 保存ID的控件，一般是个隐藏域
		 */
       commListSuggest : function(showNode,idNode,_url, _data){
    	   $(showNode).jsonSuggest({
				url : _url,
				maxResults : 10,
				minCharacters : 1,
				data:_data,
				onSelect : function(item) {
					if(null != idNode)
					{
						$(idNode).val(item.id);
				
					}
				}
			});
       },
       
		/**
		 * 通用列表补全查询，如果没有查到，则判断最后一个参数值是否需要清空表单
		 * @param showNode 显示姓名的控件
		 * @param idNode   保存ID的控件，一般是个隐藏域
		 * @param _url     请求URL
		 * @param _data    请求参数
		 * @param isClean  如果没有查询出结果，是否需要清空表单
		 */
      commListSuggest : function(showNode,idNode,_url, _data, isClean){
   	   $(showNode).jsonSuggest({
				url : _url,
				maxResults : 10,
				minCharacters : 1,
				data:_data,
				onSelect : function(item) {
					if(null != idNode)
					{
						$(idNode).val(item.id);
					}
				}
			});
   	       //判断是否需要清空
   	       if(isClean){
      	        //如果没有选中则清空内容
   		        if(idNode != null && idNode != "" && $(idNode).size() > 0){
   			        $(showNode).live('blur',function(){
   				        var idNodeValue = $(idNode).val();
   				        var length = idNodeValue.length;
   				        if(length <= 0){
   					        $(this).val('');
   				        }
   			        });
   		        }
   	       }
      },
      
       /**
		 * 通用列表补全查询，如果没有查到，则判断最后一个参数值是否需要清空表单,传入保存的ID到回调函数
		 * @param showNode 显示姓名的控件
		 * @param idNode   保存ID的控件，一般是个隐藏域
		 * @param _url     请求URL
		 * @param _data    请求参数
		 * @param isClean  如果没有查询出结果，是否需要清空表单
		 * @param callBack 回调函数
		 */
     commListSuggest : function(showNode,idNode,_url, _data, isClean,callBack){
 	   $(showNode).jsonSuggest({
				url : _url,
				maxResults : 10,
				minCharacters : 1,
				data:_data,
				onSelect : function(item) {
					if(null != idNode)
					{
						$(idNode).val(item.id);
						//如果有回调函数则执行回调函数，传入保存的ID
						if(callBack){
							callBack(item.id);
						}
					}
				}
			});
 	       //判断是否需要清空
 	       if(isClean){
    	        //如果没有选中则清空内容
 		        if(idNode != null && idNode != "" && $(idNode).size() > 0){
 			        $(showNode).live('blur',function(){
 				        var idNodeValue = $(idNode).val();
 				        var length = idNodeValue.length;
 				        if(length <= 0){
 					        $(this).val('');
 				        }
 			        });
 		        }
 	       }
      },
      
       
       /**
        * 行政区域
        * @param showNode
        * @param idNode
        * @param _flag 是否需要选中
        */
       districtSuggest : function(showNode, idNode, _flag) {
    	    
			$(showNode).jsonSuggest({
				url : "/vst_admin/biz/district/seachDistrict.do",
				maxResults : 10,
				minCharacters : 1,
				onSelect : function(item) {
					$(idNode).val(item.id);
				}
			});
		},
       
		/**
		 * 签证国家/地区模糊查询
		 * @param showNode 显示姓名的控件
		 * @param idNode 保存ID的控件，一般是个隐藏域
		 */
		visaCountrySuggest : function(showNode, idNode) {
			$(showNode).jsonSuggest({
				url : "/vst_admin/visa/visaDoc/searchVisaCountry.do",
				maxResults : 10,
				minCharacters : 1,
				emptyKeyup:false,
				onSelect : function(item) {
					$(idNode).val(item.id);
				}
			});
		},	
	
       /**
        * 页面转拼音的工具方法
        */
       convert2pinyin : function(param) {
    	   if(!param) {
    		   return "";
    	   }
    	   var result = param;
    	   $.ajax({
    		   url : "/vst_admin/pub/utils/getPinYin.do",
    		   type : "POST",
    		   async : false,
    		   data : {param:param},
    		   success : function(dt){
    			   result = dt;
    		   }
    	   });	
    	   return result;
       },
       /**
        * 页面转拼音(简拼)的工具方法
        */
       convert2shortpinyin : function(param) {
    	   if(!param) {
    		   return "";
    	   }
    	   var result = param;
    	   $.ajax({
    		   url : "/vst_admin/pub/utils/getPinYin.do?type=short",
    		   type : "POST",
    		   async : false,
    		   data : {param:param},
    		   success : function(dt){
    			   result = dt;
    		   }
    	   });	
    	   return result;
       },
       
       /**
		 * 查询主题信息
		 * @param showNode 显示姓名的控件
		 * @param idNode 保存ID的控件，一般是个隐藏域
		 * @param categoryId 品类ID
		 */
		searchBizSubject : function(showNode, idNode, categoryId) {
			$(showNode).jsonSuggest({
				url : "/vst_admin/biz/bizSubject/searchBizSubject.do?categoryId="+categoryId,
				maxResults : 10,
				minCharacters : 1,
				onSelect : function(item) {
					$(idNode).val(item.id);
				}
			});
		}
};

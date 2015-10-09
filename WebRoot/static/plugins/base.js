/**
 * 
 */

var PAGESIZE = 10;

/**
 * 格式化日期
 * @param d 值 有可能是Date类型
 * @param f	格式 yy-mm-dd hh:ii:ss
 * @returns
 */
function parseDate(d, f){
	if(!d){
		return '';
	}
	if(!f){
		f = 'yy-mm-dd';
	}
	if(f instanceof Date){
		return $.formatDateTime(f, d);
	}else if(typeof(d) == 'string'){
		if(d.indexOf('-') > -1){
			d = d.replace(/-/g,   "/");
		}
		return $.formatDateTime(f, new Date(d));
	}else if(typeof(d) == "number"){
		var date = new Date();
		date.setTime(d);
		return $.formatDateTime(f, new Date(date));
	}
}

function parseDateTime(d){
	return parseDate(d, 'yy-mm-dd hh:ii:ss');
}

function parseDateToMinus(d){
	return parseDate(d, 'yy-mm-dd hh:ii');
}

function parseDateTohi(d){
	return parseDate(d, 'hh:ii');
}

/**
 * 
 * @param form
 * @returns {Object}
 */
function getFormData(form){
	var data = new Object();
	var names = new Array();
	var s = '';
	$.each($(form).find('input,select'), function(idx, obj){
		var n = $(obj).attr('name');
		if(n && s.indexOf(n) == -1){
			names.push(n);
			s += n + ',';
		}
	});
	
	//取值
	$.each(names, function(idx, n){
		var els = $(form).find('input[name="'+n+'"],select[name="'+n+'"]');
		if(els.length == 1){
			var type = $(els[0]).attr('type');
			if(type == 'checkbox' || type == 'radio'){
				if($(els[0]).attr('checked')){
					data[n] = $(els[0]).val(); 
				}
			}else{
				data[n] = $(els[0]).val();
			}
		}else if(els.length > 1){
			data[n] = new Array();
			
			$.each(els, function(idx, el){
				var type = $(el).attr('type');
				if(type && (type == 'checkbox' || type == 'radio')){
					if($(el).attr('checked')){
						data[n].push($(el).val());
					}
				}else{
					var v = $(el).val();
					if(v){
						data[n].push(v);
					}
				}
			});
			
		}
	});
	
	return data;
}

function proVal(val){
	if(val == 0){
		return val;
	}
	if(!val){
		return '';
	}
	if(val == 'null'){
		return '';
	}
	if(val == undefined){
		return '';
	}
	if(val == 'undefined'){
		return '';
	}
	return val;
}

//正则表单时
var RE_MOBILE = /^1[3-9]\d{9}$/;
var RE_PASSWORD = /^[0-9a-zA-Z]{8,16}$/;

function checkMobile(mobile){
	return RE_MOBILE.test(mobile);
}

function checkPwd(pwd){
	return RE_PASSWORD.test(pwd);
}

function layerAlert(content, callback){
	var idx = layer.open({
	    btn: ['确定'],
	    content: content,
	    yes: function(){
	    	if(callback && typeof(callback) == 'function'){
	    		callback();
	    	}
	        layer.close(idx);
	    }
	})
}

defineClass('ViewController', {
	rightButtonItemClick() {
		var tableViewCtrl = TableViewController.alloc().init()
		self.navigationController().pushViewController_animated(tableViewCtrl, YES)
		tableViewCtrl.setTitle("JS创建的控制器");
	}
})

defineClass('TableViewController : UITableViewController <UIAlertViewDelegate>', ['data'], {
	dataSource: function() {
		var data = self.data();
		if (data) return data;
		var data = [];
		for (var i = 0; i < 30; i ++) {
			data.push("第" + (i + 1) + "行");
		}
		self.setData(data)
		return data;
	},
	numberOfSectionsInTableView: function(tableView) {
		return 1;
	},
	tableView_numberOfRowsInSection: function(tableView, section) {
		return self.dataSource().length;
	},
	tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
		var cell = tableView.dequeueReusableCellWithIdentifier("cell")
		if (!cell) {
			cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
		}
		cell.textLabel().setText(self.dataSource()[indexPath.row()])
		return cell
	},
	tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
		return 60
	},
	tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
		var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("点击了",self.dataSource()[indexPath.row()], self, "OK",  null);
		alertView.show()
	},
	alertView_willDismissWithButtonIndex: function(alertView, idx) {
		console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
	}
})

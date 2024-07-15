import { application } from "controllers/application";
import Notification from '@stimulus-components/notification'

import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

application.register('notification', Notification)

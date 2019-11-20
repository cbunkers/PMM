public with sharing class ServiceService {
    public ServiceService() {}

    public List<Object> getBulkFields() {

        List<Object> fields = new List<Object>();

        for (Schema.FieldSetMember field : Schema.SObjectType.ServiceDelivery__C.FieldSets.Default.getFields()) {

            String label;
            label = field.getLabel();

            fields.add(new Map<String, Object>{
                'apiName' => field.getFieldPath(),
                'label' => label
            });
        }

        return fields;
    }
}
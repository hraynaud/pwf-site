var SelectChosen = {
  template: ` 
    <select :data-placeholder="placeholder" :disabled="disabled" id="subject-select" >
        <option v-for="option in customOptions" v-bind:value="option.id">
            {{ option.name }}
        </option>
    </select>`,
  props: {
    value: {
      type: [String, Number, Array, Object],
      default: null
    },
    options: {
      type: [Array, Object],
      default:[] 
    },
    multiple: {
      type: Boolean,
      default: false
    },
    placeholder: {
      type: String,
      default: 'Select'
    },
    searchable: {
      type: Boolean,
      default: true
    },
    searchableMin: {
      type: Number,
      default: 1
    },
    allowEmpty: {
      type: Boolean,
      default: true
    },
    allowAll: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    },
    onValueReturn: {
      type: Object,
      default: () => {
        return {}
      }
    }
  },

  computed: {
    customOptions() {
      let vm = this,
        options = [];

      if (this.allowAll) {
        options.push({
          'id': '-1',
          'name': 'All'
        });
      }

      this.options.forEach(function (opt) {
        options.push({
          'id': opt.id,
          'name': opt.name 
        });
      });

      return this.allowEmpty ? [{id: null, label: ''}].concat(options) : options;
    },

    localValue() {
      let value = this.allowAll && this.value === null ? '-1' : this.value;
      this.$nextTick(function () {
        $(this.$el).val(value).trigger("chosen:updated");
      });

      return value;
    }
  },

  watch: {
    localValue() {
    },

    customOptions() {
      this.$nextTick(function () {
        let value = this.allowAll && this.value === null ? '-1' : this.value
        $(this.$el).val(value).trigger("chosen:updated");
      });
    }
  },

  mounted() {
    let component = this;

    $(this.$el).chosen({
      width: "100%",
      disable_search_threshold: this.searchable ? this.searchableMin : 100000
    }).change(function ($event) {
      const jqSelect = $($event.target);
      const text = jqSelect[0].selectedOptions[0].text;
      component.$emit('changed', text, jqSelect.val());
    });
  }
}
